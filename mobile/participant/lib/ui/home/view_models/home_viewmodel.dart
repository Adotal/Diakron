// home_viewmodel.dart
import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/models/coupon/coupon.dart';
import 'package:diakron_participant/models/store/store.dart';
import 'package:diakron_participant/models/users/participant.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

enum CouponSort { none, priceAsc, priceDesc, dateAsc, dateDesc }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required ParticipantRepository participantRepository})
    : _participantRepository = participantRepository {
    load = Command0(_load);
  }

  final _logger = Logger();
  final ParticipantRepository _participantRepository;

  late Command0 load;
  int _points = 0;
  int get points => _points;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];
  List<Coupon> get coupons => _filteredCoupons;

  // Manejo de tiendas
  List<Store> _allStores = [];
  List<Store> _popularStores = [];
  List<Store> get popularStores => _popularStores;

  String _searchQuery = '';

  // Categoría seleccionada
  String _selectedCategory = 'Todos';
  String get selectedCategory => _selectedCategory;

  Map<Store, List<Coupon>> _groupedCoupons = {};
  Map<Store, List<Coupon>> get groupedCoupons => _groupedCoupons;

  Store? _selectedStore;
  Store? get selectedStore => _selectedStore;

  void selectStore(Store? store) {
    _selectedStore = store;
    _applyFilters();
  }

  CouponSort _currentSort = CouponSort.none;
  CouponSort get currentSort => _currentSort;

  Participant? _participant;
  Participant get participant => _participant!;
  bool get isDisplayingGrouped =>
      _currentSort == CouponSort.none && _searchQuery.isEmpty;
  bool get isSearching =>
      _searchQuery.isNotEmpty ||
      _currentSort != CouponSort.none ||
      _selectedCategory != 'Todos';

  Future<Result<void>> _load() async {
    try {
      final participantResult = await _participantRepository.getParticipant(
        forceRefresh: true,
      );
      switch (participantResult) {
        case Success<Participant>():
          _participant = participantResult.value;
          _points = participantResult.value.points;
        case Failure<Participant>():
          return Result.error(participantResult.error);
      }

      if (_allStores.isEmpty) {
        final storesResult = await _participantRepository.fetchAllStores();
        if (storesResult is Success<List<Store>>) {
          _allStores = storesResult.value;

          // Lógica de Tiendas Populares: Ordenamos por puntos intercambiados de mayor a menor
          // y tomamos las primeras 5.
          var sortedStores = List<Store>.from(_allStores);
          sortedStores.sort(
            (a, b) =>
                (b.pointsExchanged ?? 0).compareTo(a.pointsExchanged ?? 0),
          );
          _popularStores = sortedStores.take(5).toList();
        } else {
          _logger.w('Failed to load Stores');
        }
      }

      // Obtener Cupones
      if (_allCoupons.isEmpty) {
        final result = await _participantRepository.fetchCoupons();

        switch (result) {
          case Success<List<Coupon>>():
            _allCoupons = result.value;
            _applyFilters();
            _logger.d('Loaded ${_allCoupons.length} Coupons');

          case Failure<List<Coupon>>():
            _logger.w('Failed to load Coupons ${result.error}');
        }
      }

      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateSort(CouponSort sort) {
    _currentSort = sort;
    _applyFilters();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    // 1. Aplicar Filtros (Búsqueda, Categoría y Tienda Seleccionada)
    var temp = _allCoupons.where((c) {
      final store = _allStores.firstWhere(
        (s) => s.id == c.idStore,
        orElse: () => Store(
          id: '0',
          commercialName: '',
          address: '',
          category: 'None',
          postCode: '',
          schedule: {},
          pathLogo: '',
        ),
      );

      // Filtros
      final matchesSearch =
          _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          store.commercialName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesCategory =
          _selectedCategory == 'Todos' || store.category == _selectedCategory;

      // Nueva lógica: si hay una tienda seleccionada, forzamos que sea solo esa
      final matchesStore =
          _selectedStore == null || c.idStore == _selectedStore!.id;

      return matchesSearch && matchesCategory && matchesStore;
    }).toList();

    // 2. Aplicar Ordenamiento
    switch (_currentSort) {
      case CouponSort.priceAsc:
        temp.sort((a, b) => a.pricePoints.compareTo(b.pricePoints));
        break;
      case CouponSort.priceDesc:
        temp.sort((a, b) => b.pricePoints.compareTo(a.pricePoints));
        break;
      case CouponSort.dateAsc:
        temp.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
        break;
      case CouponSort.dateDesc:
        temp.sort((a, b) => b.expirationDate.compareTo(a.expirationDate));
        break;
      case CouponSort.none:
      break;
    }

    // 3. Actualizar estados
    _filteredCoupons = temp;

    _groupedCoupons = {};
    for (var coupon in temp) {
      final store = _allStores.firstWhere((s) => s.id == coupon.idStore);
      if (!_groupedCoupons.containsKey(store)) _groupedCoupons[store] = [];
      _groupedCoupons[store]!.add(coupon);
    }

    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = "";
    _currentSort = CouponSort.none;
    _selectedCategory = 'Todos';
    _selectedStore = null;
    _applyFilters();
  }
}
