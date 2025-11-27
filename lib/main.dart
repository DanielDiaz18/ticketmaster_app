import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmaster_app/screens/category_screen.dart';
import 'core/analytics/analytics_service.dart';
import 'services/inventory_service.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AnalyticsService>(create: (context) => AnalyticsService()),
        Provider<InventoryService>(create: (context) => InventoryService()),
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(
            analyticsService: context.read<AnalyticsService>(),
            inventoryService: context.read<InventoryService>(),
          ),
        ),
      ],
      child: const TicketMasterApp(),
    ),
  );
}

class TicketMasterApp extends StatefulWidget {
  const TicketMasterApp({super.key});

  @override
  State<TicketMasterApp> createState() => _TicketMasterAppState();
}

class _TicketMasterAppState extends State<TicketMasterApp> {
  @override
  void initState() {
    super.initState();
    final analyticsService = context.read<AnalyticsService>();
    analyticsService.trackEvent(AnalyticsEvent.appOpened);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = FlexScheme.material;
    return MaterialApp(
      title: 'TicketMaster',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        // Using FlexColorScheme built-in FlexScheme enum based colors
        scheme: FlexScheme.blumineBlue,
        // Surface color adjustments.
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 1,
        // Component theme configurations for light mode.
        subThemesData: const FlexSubThemesData(
          interactionEffects: true,
          tintedDisabledControls: true,
          blendOnLevel: 8,
          useM2StyleDividerInM3: true,
          defaultRadius: 12.0,
          elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          toggleButtonsBorderSchemeColor: SchemeColor.primary,
          segmentedButtonSchemeColor: SchemeColor.primary,
          segmentedButtonBorderSchemeColor: SchemeColor.primary,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorIsFilled: true,
          inputDecoratorBackgroundAlpha: 31,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorFocusedBorderWidth: 1.0,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          fabUseShape: true,
          fabAlwaysCircular: true,
          fabSchemeColor: SchemeColor.tertiary,
          popupMenuRadius: 8.0,
          popupMenuElevation: 3.0,
          alignedDropdown: true,
          drawerIndicatorRadius: 12.0,
          drawerIndicatorSchemeColor: SchemeColor.primary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarMutedUnselectedIcon: false,
          menuRadius: 8.0,
          menuElevation: 3.0,
          menuBarRadius: 0.0,
          menuBarElevation: 2.0,
          menuBarShadowColor: Color(0x00000000),
          searchBarElevation: 1.0,
          searchViewElevation: 1.0,
          searchUseGlobalShape: true,
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationBarIndicatorSchemeColor: SchemeColor.primary,
          navigationBarIndicatorRadius: 12.0,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationRailUseIndicator: true,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 1.00,
          navigationRailIndicatorRadius: 12.0,
          navigationRailBackgroundSchemeColor: SchemeColor.surface,
        ),
        // ColorScheme seed generation configuration for light mode.
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
          keepPrimary: true,
        ),
        tones: FlexSchemeVariant.jolly.tones(Brightness.light),
        // Direct ThemeData properties.
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
      ),
      themeMode: ThemeMode.system,

      home: const CategoryScreen(),
    );
  }
}
