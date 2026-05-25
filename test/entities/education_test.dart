import 'package:flutter_test/flutter_test.dart';
import 'package:open_budget/core/domain/entities/education.dart';

void main() {
  group('EducationContent', () {
    test('creates with required fields', () {
      final e = EducationContent(
        id: 'e1',
        title: 'Zero-Sum Budgeting',
        description: 'Learn the basics',
        type: ContentType.article,
        content: 'Full article content here.',
        iconName: 'shield_rounded',
        createdAt: DateTime(2026, 1, 1),
      );
      expect(e.title, 'Zero-Sum Budgeting');
      expect(e.type, ContentType.article);
      expect(e.difficulty, DifficultyLevel.beginner);
      expect(e.readTimeMinutes, 5);
      expect(e.isPremium, false);
    });

    test('ContentType enum has 4 values', () {
      expect(ContentType.values.length, 4);
      expect(ContentType.values, contains(ContentType.tip));
      expect(ContentType.values, contains(ContentType.article));
      expect(ContentType.values, contains(ContentType.challenge));
      expect(ContentType.values, contains(ContentType.course));
    });

    test('DifficultyLevel enum has 3 values', () {
      expect(DifficultyLevel.values.length, 3);
      expect(DifficultyLevel.values, contains(DifficultyLevel.beginner));
      expect(DifficultyLevel.values, contains(DifficultyLevel.intermediate));
      expect(DifficultyLevel.values, contains(DifficultyLevel.advanced));
    });

    test('Equatable comparison works', () {
      final now = DateTime(2026, 1, 1);
      final a = EducationContent(
        id: 'e1', title: 'Title', description: 'Desc',
        type: ContentType.tip, content: 'Content',
        iconName: 'bolt', createdAt: now,
      );
      final b = EducationContent(
        id: 'e1', title: 'Title', description: 'Desc',
        type: ContentType.tip, content: 'Content',
        iconName: 'bolt', createdAt: now,
      );
      expect(a, equals(b));
    });
  });

  group('UserProgress', () {
    test('creates with default values', () {
      final p = UserProgress(contentId: 'e1');
      expect(p.contentId, 'e1');
      expect(p.isCompleted, false);
      expect(p.isBookmarked, false);
      expect(p.progressPercent, 0);
    });

    test('copyWith works', () {
      final p = UserProgress(contentId: 'e1');
      final updated = p.copyWith(isCompleted: true, progressPercent: 100);
      expect(updated.isCompleted, true);
      expect(updated.progressPercent, 100);
      expect(updated.contentId, 'e1');
    });
  });
}
