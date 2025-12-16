import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/presentation/widgets/primary_button.dart';

class BeautifulGrabAddressPicker extends StatefulWidget {
  final LatLng? initialPosition;
  final String? initialAddress;

  const BeautifulGrabAddressPicker({
    super.key,
    this.initialPosition,
    this.initialAddress,
  });

  @override
  State<BeautifulGrabAddressPicker> createState() =>
      _BeautifulGrabAddressPickerState();
}

class _BeautifulGrabAddressPickerState
    extends State<BeautifulGrabAddressPicker> {
  // Constants
  static const _defaultPosition = LatLng(10.8231, 106.6297); // HCMC
  static const _emulatorPosition = LatLng(37.4219983, -122.084);
  static const _defaultZoom = 16.0;
  static const _searchLimit = 8;
  static const _maxKeywords = 6;

  // Controllers
  final _mapController = MapController();
  final _addressController = TextEditingController();

  // State variables - Selection
  LatLng? _selectedPosition;
  int? _selectedSuggestionIndex;
  String? _selectedAddressFromSuggestion;
  List<Map<String, dynamic>> _suggestions = [];

  // State variables - Flags
  bool _confirmedOnce = false;
  bool _disableSuggestions = false;
  bool _isFromMap = false;
  bool _isFromSuggestion = false;
  bool _isUpdatingFromMap = false;
  bool _hasValidLocation = false; // Đánh dấu đã chọn vị trí hợp lệ

  @override
  void initState() {
    super.initState();
    _initializePosition();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  // ============================================================
  // Initialization
  // ============================================================
  void _initializePosition() {
    if (widget.initialPosition != null) {
      _selectedPosition = widget.initialPosition;
      _addressController.text = widget.initialAddress ?? '';
      _hasValidLocation = true; // ✅ Initial position là hợp lệ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_selectedPosition!, _defaultZoom);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
    }
  }

  Future<void> _initLocation() async {
    var permission = await Geolocator.checkPermission();
    debugPrint("Permission status: $permission");

    // Nếu denied → xin lại quyền
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      debugPrint("After request: $permission");
    }

    // Nếu deniedForever → hiện dialog mở Cài đặt
    if (permission == LocationPermission.deniedForever) {
      final openSettings = await _showPermissionDialog();

      if (openSettings == true) {
        await Geolocator.openAppSettings();
        // TODO: Có thể thêm lifecycle observer để theo dõi khi user quay lại
      }

      // Fallback về vị trí mặc định
      _moveToDefaultLocation();
      return;
    }

    // Nếu vẫn denied → fallback
    if (permission == LocationPermission.denied) {
      _moveToDefaultLocation();
      return;
    }

    // Nếu đã có quyền → lấy vị trí
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentPosition();
    }
  }

  Future<bool?> _showPermissionDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.backgroundMain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Cần quyền vị trí",
          style: TextStyle(color: AppColors.primary,),
        ),
        content: const Text(
          "Bạn đã từ chối quyền vị trí nhiều lần. \nBạn muốn mở Cài đặt để bật lại quyền không?",
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(

            onPressed: () => Navigator.pop(context, false),
            child: const Text("Không", style: TextStyle(color: AppColors.primary),),
          ),
          ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor:AppColors.backgroundMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Mở cài đặt"),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      debugPrint("GPS >>> ${pos.latitude}, ${pos.longitude}");

      LatLng newLocation;

      // Check for emulator position
      if (pos.latitude == _emulatorPosition.latitude &&
          pos.longitude == _emulatorPosition.longitude) {
        newLocation = _defaultPosition;
      } else {
        newLocation = LatLng(pos.latitude, pos.longitude);
      }

      setState(() {
        _selectedPosition = newLocation;
        _hasValidLocation = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _mapController.move(_selectedPosition!, _defaultZoom);
        await _updateAddressFromLatLng(_selectedPosition!);
      });
    } catch (e) {
      debugPrint("Error getCurrentPosition: $e");
      _moveToDefaultLocation();
    }
  }

  void _moveToDefaultLocation() {
    setState(() {
      _selectedPosition = _defaultPosition;
      _hasValidLocation = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _mapController.move(_selectedPosition!, _defaultZoom);
      await _updateAddressFromLatLng(_selectedPosition!);
    });
  }

  Future<LocationPermission> checkAndRequestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }
  // void _initializePosition() {
  //   if (widget.initialPosition != null) {
  //     _selectedPosition = widget.initialPosition;
  //     _addressController.text = widget.initialAddress ?? '';
  //     _hasValidLocation = true; // Initial position là hợp lệ
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _mapController.move(_selectedPosition!, _defaultZoom);
  //     });
  //   } else {
  //     WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  //   }
  // }
  //
  // Future<void> _initLocation() async {
  //   final position = await _getCurrentPosition();
  //   setState(() {
  //     _selectedPosition = position;
  //     _hasValidLocation = true; // Vị trí hiện tại là hợp lệ
  //   });
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     _mapController.move(_selectedPosition!, _defaultZoom);
  //     await _updateAddressFromLatLng(_selectedPosition!);
  //   });
  // }
  //
  // Future<LatLng> _getCurrentPosition() async {
  //   final permission = await _checkLocationPermission();
  //
  //   if (permission == LocationPermission.deniedForever ||
  //       permission == LocationPermission.denied) {
  //     return _defaultPosition;
  //   }
  //
  //   try {
  //     final pos = await Geolocator.getCurrentPosition();
  //     debugPrint("GPS >>> ${pos.latitude}, ${pos.longitude}");
  //
  //     // Check for emulator position
  //     if (pos.latitude == _emulatorPosition.latitude &&
  //         pos.longitude == _emulatorPosition.longitude) {
  //       return _defaultPosition;
  //     }
  //
  //     return LatLng(pos.latitude, pos.longitude);
  //   } catch (e) {
  //     debugPrint("Error getting position: $e");
  //     return _defaultPosition;
  //   }
  // }
  //
  // Future<LocationPermission> _checkLocationPermission() async {
  //   var permission = await Geolocator.checkPermission();
  //   debugPrint("Permission status: $permission");
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     debugPrint("After request: $permission");
  //   }
  //
  //   return permission;
  // }

  // ============================================================
  // Address Operations
  // ============================================================

  Future<void> _updateAddressFromLatLng(LatLng point) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );

      if (placemarks.isEmpty || _confirmedOnce) return;

      final placemark = placemarks.first;
      final address = _formatAddress(placemark);

      if (address.isNotEmpty) {
        _addressController.text = address;
      }
    } catch (e) {
      debugPrint("Error getting address from coordinates: $e");
    }
  }

  String _formatAddress(Placemark placemark) {
    final parts = [
      placemark.street,
      placemark.subLocality,
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
    ];

    return parts
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(", ");
  }

  // ============================================================
  // Search Operations
  // ============================================================

  Future<List<Map<String, dynamic>>> _searchAddress(String query) async {
    if (_isFromMap || query.isEmpty) {
      return [];
    }

    // Try hierarchical search first
    final hierarchicalResults = await _hierarchicalSearch(query);
    if (hierarchicalResults.isNotEmpty) {
      return hierarchicalResults;
    }

    // Fallback to keyword search
    return _keywordSearch(query);
  }

  Future<List<Map<String, dynamic>>> _hierarchicalSearch(String query) async {
    final parts = query.split(",").map((e) => e.trim()).toList();

    for (int i = parts.length; i > 0; i--) {
      final subQuery = parts.take(i).join(", ");
      final results = await _performSearch(subQuery);

      if (results.isNotEmpty) {
        // debugPrint(" Found suggestions for: $subQuery");
        return results;
      }
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> _keywordSearch(String query) async {
    final words = query.split(" ");
    final keyQuery = words.take(_maxKeywords).join(" ");
    return _performSearch(keyQuery);
  }

  Future<List<Map<String, dynamic>>> _performSearch(String query) async {
    final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?"
            "q=${Uri.encodeComponent(query)}"
            "&format=json"
            "&addressdetails=1"
            "&limit=$_searchLimit"
            "&countrycodes=vn"
            "&accept-language=vi"
    );

    try {
      final response = await http.get(
        url,
        headers: {"User-Agent": "flutter-app"},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Error searching for $query: $e");
    }

    return [];
  }

  // ============================================================
  // Event Handlers
  // ============================================================

  void _onMapTap(TapPosition tapPos, LatLng point) async {
    setState(() {
      _isFromMap = true;
      _isFromSuggestion = false;
      _disableSuggestions = true;
      _selectedPosition = point;
      _selectedSuggestionIndex = null;
      _hasValidLocation = true; // Đánh dấu đã chọn vị trí hợp lệ
    });

    FocusScope.of(context).unfocus();

    _isUpdatingFromMap = true;
    await _updateAddressFromLatLng(point);
    _isUpdatingFromMap = false;
  }

  void _onSuggestionTap(Map<String, dynamic> suggestion, int index) {
    final lat = double.parse(suggestion["lat"]);
    final lon = double.parse(suggestion["lon"]);
    final display = suggestion["display_name"] ?? "";

    setState(() {
      _selectedSuggestionIndex = index;
      _isFromSuggestion = true;
      _isFromMap = false;
      _selectedPosition = LatLng(lat, lon);
      _selectedAddressFromSuggestion = display;
      _confirmedOnce = false;
      _hasValidLocation = true; // Đánh dấu đã chọn vị trí hợp lệ
    });

    _mapController.move(_selectedPosition!, _defaultZoom);
  }

  void _onConfirmPressed() {
    //  Kiểm tra xem đã chọn vị trí hợp lệ chưa
    if (!_hasValidLocation) {
      _showErrorDialog(
        "Vui lòng chọn địa chỉ hợp lệ",
      );
      return;
    }

    //  Kiểm tra địa chỉ không được rỗng
    if (_addressController.text.trim().isEmpty) {
      _showErrorDialog("Vui lòng nhập địa chỉ");
      return;
    }

    final result = {
      "address": _addressController.text,
      "lat": _selectedPosition!.latitude,
      "lng": _selectedPosition!.longitude,
    };

    // From map - confirm immediately
    if (_isFromMap) {
      Navigator.pop(context, result);
      return;
    }

    // From suggestion - first press: update textfield
    if (_isFromSuggestion && !_confirmedOnce) {
      _confirmedOnce = true;
      if (_selectedAddressFromSuggestion != null) {
        _addressController.text = _selectedAddressFromSuggestion!;
      }
      FocusScope.of(context).unfocus();
      setState(() => _suggestions.clear());
      return;
    }

    // From suggestion - second press or manual input: confirm
    Navigator.pop(context, result);
  }

  void _onTextChanged(String value) {
    if (!_isUpdatingFromMap) {
      setState(() {
        _disableSuggestions = false;
        _isFromMap = false;
        _isFromSuggestion = false;
        _confirmedOnce = false;
        _hasValidLocation = false; // Reset khi user nhập thủ công
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundMain,
        title: const Text(
          "Thông báo",
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor:AppColors.backgroundMain,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Đã hiểu"),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UI Builders
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_selectedPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMap(),
          _buildSearchBar(),
          _buildConfirmButton(),
          _locationButton(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _selectedPosition!,
        initialZoom: _defaultZoom,
        onTap: _onMapTap,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        _buildMarkerLayer(),
      ],
    );
  }

  Widget _buildMarkerLayer() {
    return MarkerLayer(
      markers: [
        Marker(
          point: _selectedPosition!,
          width: 50,
          height: 50,
          child: const Icon(
            Icons.location_on,
            color: AppColors.marker,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50,
      left: 15,
      right: 15,
      child: TypeAheadField<Map<String, dynamic>>(
        hideOnEmpty: true,
        hideOnError: true,
        hideOnLoading: false,
        loadingBuilder: (_) =>  Container(
          color:  AppColors.backgroundSecondary,
          padding: EdgeInsets.all(12),
          child: LinearProgressIndicator(
            minHeight: 2,
            color: AppColors.primary, // màu chính của progress
            backgroundColor: AppColors.backgroundMain, // màu nền thanh tiến trình
          ),
        ),

        controller: _addressController,
        onSelected: null,
        suggestionsCallback: (pattern) async {
          if (_confirmedOnce || _isUpdatingFromMap || _disableSuggestions) {
            return [];
          }
          final results = await _searchAddress(pattern);
          setState(() => _suggestions = results);
          return results;
        },
        itemBuilder: (context, suggestion) {
          final index = _suggestions.indexOf(suggestion);
          return _buildSuggestionItem(suggestion, index);
        },
        builder: (context, controller, focusNode) {
          return _buildTextField(controller, focusNode);
        },
      ),
    );
  }

  Widget _buildSuggestionItem(Map<String, dynamic> suggestion, int index) {
    final isSelected = index == _selectedSuggestionIndex;
    final display = suggestion["display_name"] ?? "";
    final parts = display.split(", ");
    final title = parts.isNotEmpty ? parts.first : display;
    final subtitle = parts.length > 1 ? parts.sublist(1).join(", ") : "";

    return InkWell(
      onTap: () => _onSuggestionTap(suggestion, index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.backgroundThird,
        ),
        child: ListTile(
          leading: Icon(
            Icons.location_on,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, FocusNode focusNode) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: _onTextChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Nhập địa chỉ...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  Widget _locationButton() {
    return Positioned(
      right: 16,
      bottom: 110,
      child: FloatingActionButton(
        heroTag: 'location',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: _initLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
  Widget _buildConfirmButton() {
    return Positioned(
      bottom:  MediaQuery.of(context).padding.bottom + 40,
      left: 15,
      right: 15,
      child: PrimaryButton(
        label: "Xác nhận vị trí",
        onPressed: _onConfirmPressed,
      ),
    );
  }
}