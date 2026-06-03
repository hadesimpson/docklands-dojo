import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/theme/dojo_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BeltRank enum', () {
    test('has exactly 11 values', () {
      expect(BeltRank.values.length, 11);
    });

    test('values are in correct order (kyu10 first, shodan last)', () {
      expect(BeltRank.values.first, BeltRank.kyu10);
      expect(BeltRank.values.last, BeltRank.shodan);
    });
  });

  group('BeltRankMetadata ordering', () {
    test('order values are 0 through 10', () {
      for (var i = 0; i < BeltRank.values.length; i++) {
        expect(BeltRank.values[i].order, i);
      }
    });

    test('sorting by order produces correct sequence', () {
      final shuffled = List<BeltRank>.from(BeltRank.values)
        ..shuffle()
        ..sort((a, b) => a.order.compareTo(b.order));
      expect(shuffled, BeltRank.values);
    });

    test('each rank has a unique order', () {
      final orders = BeltRank.values.map((r) => r.order).toSet();
      expect(orders.length, BeltRank.values.length);
    });
  });

  group('BeltRankMetadata IKO-1 colors', () {
    test('kyu10 is White', () {
      expect(BeltRank.kyu10.primaryColor, DojoColors.beltWhite);
      expect(BeltRank.kyu10.colorDescription, 'White');
    });

    test('kyu9 is Orange', () {
      expect(BeltRank.kyu9.primaryColor, DojoColors.beltOrange);
      expect(BeltRank.kyu9.colorDescription, 'Orange');
    });

    test('kyu8 is Orange with Blue stripe', () {
      expect(BeltRank.kyu8.primaryColor, DojoColors.beltOrange);
      expect(BeltRank.kyu8.stripeColor, DojoColors.stripeBlue);
      expect(BeltRank.kyu8.colorDescription, 'Orange with Blue stripe');
    });

    test('kyu7 is Blue', () {
      expect(BeltRank.kyu7.primaryColor, DojoColors.beltBlue);
      expect(BeltRank.kyu7.colorDescription, 'Blue');
    });

    test('kyu6 is Blue with Yellow stripe', () {
      expect(BeltRank.kyu6.primaryColor, DojoColors.beltBlue);
      expect(BeltRank.kyu6.stripeColor, DojoColors.stripeYellow);
      expect(BeltRank.kyu6.colorDescription, 'Blue with Yellow stripe');
    });

    test('kyu5 is Yellow', () {
      expect(BeltRank.kyu5.primaryColor, DojoColors.beltYellow);
      expect(BeltRank.kyu5.colorDescription, 'Yellow');
    });

    test('kyu4 is Yellow with Green stripe', () {
      expect(BeltRank.kyu4.primaryColor, DojoColors.beltYellow);
      expect(BeltRank.kyu4.stripeColor, DojoColors.stripeGreen);
      expect(BeltRank.kyu4.colorDescription, 'Yellow with Green stripe');
    });

    test('kyu3 is Green', () {
      expect(BeltRank.kyu3.primaryColor, DojoColors.beltGreen);
      expect(BeltRank.kyu3.colorDescription, 'Green');
    });

    test('kyu2 is Brown', () {
      expect(BeltRank.kyu2.primaryColor, DojoColors.beltBrown);
      expect(BeltRank.kyu2.colorDescription, 'Brown');
    });

    test('kyu1 is Brown', () {
      expect(BeltRank.kyu1.primaryColor, DojoColors.beltBrown);
      expect(BeltRank.kyu1.colorDescription, 'Brown');
    });

    test('shodan is Black', () {
      expect(BeltRank.shodan.primaryColor, DojoColors.beltBlack);
      expect(BeltRank.shodan.colorDescription, 'Black');
    });
  });

  group('BeltRankMetadata stripe detection', () {
    test('only kyu8, kyu6, and kyu4 have stripes', () {
      final stripedBelts = BeltRank.values.where((r) => r.hasStripe).toList();
      expect(stripedBelts, [BeltRank.kyu8, BeltRank.kyu6, BeltRank.kyu4]);
    });

    test('non-striped belts have null stripeColor', () {
      final solidBelts = BeltRank.values.where((r) => !r.hasStripe);
      for (final belt in solidBelts) {
        expect(
          belt.stripeColor,
          isNull,
          reason: '${belt.name} should be solid',
        );
      }
    });

    test('stripe colors reference DojoColors constants', () {
      expect(BeltRank.kyu8.stripeColor, const Color(0xFF0047AB));
      expect(BeltRank.kyu6.stripeColor, const Color(0xFFFFD700));
      expect(BeltRank.kyu4.stripeColor, const Color(0xFF228B22));
    });
  });

  group('BeltRankMetadata Japanese names', () {
    test('kyu10 is Jūkyū', () {
      expect(BeltRank.kyu10.japaneseName, 'Jūkyū');
    });

    test('kyu9 is Kukyū', () {
      expect(BeltRank.kyu9.japaneseName, 'Kukyū');
    });

    test('kyu8 is Hachikyū', () {
      expect(BeltRank.kyu8.japaneseName, 'Hachikyū');
    });

    test('kyu7 is Nanakyū', () {
      expect(BeltRank.kyu7.japaneseName, 'Nanakyū');
    });

    test('kyu6 is Rokkyū', () {
      expect(BeltRank.kyu6.japaneseName, 'Rokkyū');
    });

    test('kyu5 is Gokyū', () {
      expect(BeltRank.kyu5.japaneseName, 'Gokyū');
    });

    test('kyu4 is Yonkyū', () {
      expect(BeltRank.kyu4.japaneseName, 'Yonkyū');
    });

    test('kyu3 is Sankyū', () {
      expect(BeltRank.kyu3.japaneseName, 'Sankyū');
    });

    test('kyu2 is Nikyū', () {
      expect(BeltRank.kyu2.japaneseName, 'Nikyū');
    });

    test('kyu1 is Ikkyū', () {
      expect(BeltRank.kyu1.japaneseName, 'Ikkyū');
    });

    test('shodan is Shodan', () {
      expect(BeltRank.shodan.japaneseName, 'Shodan');
    });

    test('every rank has a non-empty Japanese name', () {
      for (final rank in BeltRank.values) {
        expect(
          rank.japaneseName.isNotEmpty,
          isTrue,
          reason: '${rank.name} should have a Japanese name',
        );
      }
    });
  });

  group('BeltRankMetadata display names', () {
    test('kyu10 displays as 10th Kyu', () {
      expect(BeltRank.kyu10.displayName, '10th Kyu');
    });

    test('shodan displays as Shodan', () {
      expect(BeltRank.shodan.displayName, 'Shodan');
    });

    test('every rank has a non-empty display name', () {
      for (final rank in BeltRank.values) {
        expect(
          rank.displayName.isNotEmpty,
          isTrue,
          reason: '${rank.name} should have a display name',
        );
      }
    });
  });
}
