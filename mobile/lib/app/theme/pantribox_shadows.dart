import 'package:flutter/material.dart';

abstract final class PantriBoxShadows {
  static const legacyCard = <BoxShadow>[
    BoxShadow(color: Color(0x140E160F), blurRadius: 18, offset: Offset(0, 8)),
  ];

  static const v2Card = <BoxShadow>[
    BoxShadow(color: Color(0x120E120F), blurRadius: 30, offset: Offset(0, 14)),
    BoxShadow(color: Color(0x0A0E120F), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const v2Floating = <BoxShadow>[
    BoxShadow(color: Color(0x120E120F), blurRadius: 32, offset: Offset(0, 12)),
  ];
}
