import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';

import 'program_detail_page.dart';

class ProgramListingsPage extends StatelessWidget {
  const ProgramListingsPage({super.key});

  final List<Map<String, dynamic>> programs = const [
    {
      'id': '1',
      'title': 'Cybersecurity Fundamentals',
      'description':
          'Learn the basics of cybersecurity: threats, defenses, and best practices.',
      'duration': '6 weeks',
      'level': 'Intermediate',
      'learning': [
        'Understand common cyber threats and attack vectors',
        'Learn basic network and system hardening techniques',
        'Hands-on practice with security tools and analysis',
        'Incident response basics and mitigation strategies',
      ],
      'modules': [
        {
          'week': 'Week 1-2',
          'title': 'Security Fundamentals & Threats',
          'tasks': [
            {
              'name': 'Reading: Introduction to Cybersecurity',
              'type': 'reading',
            },
            {'name': 'Quiz: Common Threats', 'type': 'quiz'},
            {'name': 'Mini Project: Threat Analysis', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 3-4',
          'title': 'Network & System Hardening',
          'tasks': [
            {'name': 'Reading: Network Security Basics', 'type': 'reading'},
            {'name': 'Quiz: Security Protocols', 'type': 'quiz'},
            {'name': 'Mini Project: Secure a Network', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 5-6',
          'title': 'Tools, Detection & Response',
          'tasks': [
            {'name': 'Reading: Security Tools Overview', 'type': 'reading'},
            {'name': 'Quiz: Incident Response', 'type': 'quiz'},
            {'name': 'Mini Project: Security Audit', 'type': 'project'},
          ],
        },
      ],
    },
    {
      'id': '2',
      'title': 'Web Development Bootcamp',
      'description': 'Master HTML, CSS, JavaScript and modern frameworks',
      'duration': '8 weeks',
      'level': 'Intermediate',
      'learning': [
        'Build responsive web pages',
        'Understand JavaScript fundamentals and DOM manipulation',
        'Work with a modern frontend framework',
        'Deploy and host web applications',
      ],
      'modules': [
        {
          'week': 'Week 1-2',
          'title': 'HTML & CSS Essentials',
          'tasks': [
            {'name': 'Reading: HTML5 Fundamentals', 'type': 'reading'},
            {'name': 'Quiz: CSS Selectors', 'type': 'quiz'},
            {'name': 'Mini Project: Personal Portfolio', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 3-4',
          'title': 'JavaScript & DOM',
          'tasks': [
            {'name': 'Reading: JavaScript Basics', 'type': 'reading'},
            {'name': 'Quiz: DOM Manipulation', 'type': 'quiz'},
            {'name': 'Mini Project: Interactive Calculator', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 5-6',
          'title': 'Frontend Frameworks',
          'tasks': [
            {'name': 'Reading: React Fundamentals', 'type': 'reading'},
            {'name': 'Quiz: Component Lifecycle', 'type': 'quiz'},
            {'name': 'Mini Project: Todo App', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 7-8',
          'title': 'Project & Deployment',
          'tasks': [
            {'name': 'Reading: Deployment Best Practices', 'type': 'reading'},
            {'name': 'Quiz: Git & Version Control', 'type': 'quiz'},
            {'name': 'Final Project: Full Website', 'type': 'project'},
          ],
        },
      ],
    },
    {
      'id': '3',
      'title': 'Data Analytics with Python',
      'description': 'Analyze data and create insights using Python',
      'duration': '6 weeks',
      'level': 'Intermediate',
      'learning': [
        'Data wrangling with pandas',
        'Data visualization with matplotlib/seaborn',
        'Basic statistical analysis',
        'Intro to machine learning workflows',
      ],
      'modules': [
        {
          'week': 'Week 1-2',
          'title': 'Python & Data Wrangling',
          'tasks': [
            {'name': 'Reading: Python for Data Science', 'type': 'reading'},
            {'name': 'Quiz: Pandas Basics', 'type': 'quiz'},
            {'name': 'Mini Project: Data Cleaning', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 3-4',
          'title': 'Visualization & EDA',
          'tasks': [
            {'name': 'Reading: Data Visualization', 'type': 'reading'},
            {'name': 'Quiz: Chart Types', 'type': 'quiz'},
            {'name': 'Mini Project: Sales Dashboard', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 5-6',
          'title': 'Intro to ML & Case Study',
          'tasks': [
            {'name': 'Reading: ML Fundamentals', 'type': 'reading'},
            {'name': 'Quiz: ML Algorithms', 'type': 'quiz'},
            {'name': 'Final Project: Predictive Model', 'type': 'project'},
          ],
        },
      ],
    },
    {
      'id': '4',
      'title': 'Mobile App Development',
      'description': 'Build iOS and Android apps with Flutter',
      'duration': '10 weeks',
      'level': 'Advanced',
      'learning': [
        'Build multi-screen mobile apps with Flutter',
        'State management and backend integration',
        'Platform-specific features and deployment',
      ],
      'modules': [
        {
          'week': 'Week 1-2',
          'title': 'Flutter Basics',
          'tasks': [
            {'name': 'Reading: Dart & Flutter Intro', 'type': 'reading'},
            {'name': 'Quiz: Widget Fundamentals', 'type': 'quiz'},
            {'name': 'Mini Project: Hello World App', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 3-5',
          'title': 'State & Navigation',
          'tasks': [
            {'name': 'Reading: State Management', 'type': 'reading'},
            {'name': 'Quiz: Navigation Patterns', 'type': 'quiz'},
            {'name': 'Mini Project: Multi-Screen App', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 6-8',
          'title': 'Backend Integration',
          'tasks': [
            {'name': 'Reading: REST APIs & Firebase', 'type': 'reading'},
            {'name': 'Quiz: HTTP & Data', 'type': 'quiz'},
            {'name': 'Mini Project: Weather App', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 9-10',
          'title': 'Testing & Deployment',
          'tasks': [
            {'name': 'Reading: App Store Guidelines', 'type': 'reading'},
            {'name': 'Quiz: Testing Best Practices', 'type': 'quiz'},
            {'name': 'Final Project: Published App', 'type': 'project'},
          ],
        },
      ],
    },
    {
      'id': '5',
      'title': 'AI & ML Skill Development',
      'description':
          'Hands-on introduction to AI and machine learning workflows and tools.',
      'duration': '8 weeks',
      'level': 'Intermediate',
      'learning': [
        'Understand core ML concepts and algorithms',
        'Prepare datasets and feature engineering',
        'Train and evaluate ML models',
        'Deploy simple ML models and build projects',
      ],
      'modules': [
        {
          'week': 'Week 1-2',
          'title': 'Intro to AI & ML Concepts',
          'tasks': [
            {'name': 'Reading: What is AI?', 'type': 'reading'},
            {'name': 'Quiz: ML Terminology', 'type': 'quiz'},
            {'name': 'Mini Project: Linear Regression', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 3-4',
          'title': 'Data Preparation & Features',
          'tasks': [
            {'name': 'Reading: Feature Engineering', 'type': 'reading'},
            {'name': 'Quiz: Data Preprocessing', 'type': 'quiz'},
            {'name': 'Mini Project: Data Pipeline', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 5-6',
          'title': 'Model Training & Evaluation',
          'tasks': [
            {
              'name': 'Reading: Classification vs Regression',
              'type': 'reading',
            },
            {'name': 'Quiz: Model Metrics', 'type': 'quiz'},
            {'name': 'Mini Project: Image Classifier', 'type': 'project'},
          ],
        },
        {
          'week': 'Week 7-8',
          'title': 'Deployment & Project',
          'tasks': [
            {'name': 'Reading: ML in Production', 'type': 'reading'},
            {'name': 'Quiz: Deployment Strategies', 'type': 'quiz'},
            {'name': 'Final Project: AI Chatbot', 'type': 'project'},
          ],
        },
      ],
    },
  ];

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Palette.success;
      case 'intermediate':
        return Palette.warning;
      case 'advanced':
        return Palette.error;
      default:
        return Palette.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        backgroundColor: Palette.primary,
        foregroundColor: Palette.textOnPrimary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Palette.background, Palette.surface],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: programs.length,
          itemBuilder: (context, index) {
            final program = programs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              color: Palette.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramDetailPage(program: program),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              program['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Palette.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getLevelColor(program['level'] ?? ''),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              program['level'] ?? '',
                              style: const TextStyle(
                                color: Palette.textOnPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        program['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Palette.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Palette.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            program['duration'] ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Palette.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'View Details',
                            style: TextStyle(
                              color: Palette.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Palette.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
