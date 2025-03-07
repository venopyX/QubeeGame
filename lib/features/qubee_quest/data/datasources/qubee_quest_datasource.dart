import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/qubee_model.dart';
import '../models/land_model.dart';

class QubeeQuestDatasource {
  Future<List<QubeeModel>> getQubeeLetters() async {
    // In a real app, this would load from assets or API
    final String response = await rootBundle.loadString('assets/data/qubee_letters.json');
    final data = json.decode(response) as List;
    return data.map((json) => QubeeModel.fromJson(json)).toList();
  }
  
  Future<List<LandModel>> getLands() async {
    // In a real app, this would load from assets or API
    final String response = await rootBundle.loadString('assets/data/qubee_lands.json');
    final data = json.decode(response) as List;
    return data.map((json) => LandModel.fromJson(json)).toList();
  }

  // For development purposes, we'll provide sample data if the JSON files don't exist yet
  Future<List<QubeeModel>> getSampleQubeeLetters() async {
    return [
      QubeeModel(
        id: 1,
        letter: 'A',
        pronunciation: 'Ah',
        soundPath: 'assets/audio/a.mp3',
        tracingPoints: _generateTracingPoints('A'),
        unlockedWords: ['Abbaa'],
        requiredPoints: 0,
      ),
      QubeeModel(
        id: 2,
        letter: 'B',
        pronunciation: 'Bu',
        soundPath: 'assets/audio/b.mp3',
        tracingPoints: _generateTracingPoints('B'),
        unlockedWords: ['Biyya'],
        requiredPoints: 10,
      ),
      QubeeModel(
        id: 3,
        letter: 'C',
        pronunciation: 'Chu',
        soundPath: 'assets/audio/c.mp3',
        tracingPoints: _generateTracingPoints('C'),
        unlockedWords: ['Cabsa'],
        requiredPoints: 20,
      ),
      QubeeModel(
        id: 4,
        letter: 'D',
        pronunciation: 'Du',
        soundPath: 'assets/audio/d.mp3',
        tracingPoints: _generateTracingPoints('D'),
        unlockedWords: ['Damma'],
        requiredPoints: 30,
      ),
      QubeeModel(
        id: 5,
        letter: 'E',
        pronunciation: 'Eh',
        soundPath: 'assets/audio/e.mp3',
        tracingPoints: _generateTracingPoints('E'),
        unlockedWords: ['Eeboo'],
        requiredPoints: 40,
      ),
    ];
  }

  Future<List<LandModel>> getSampleLands() async {
    return [
      LandModel(
        id: 1,
        name: 'Green Valleys',
        description: 'A beautiful land where your Qubee journey begins',
        imagePath: 'assets/images/lands/green_valleys.jpg',
        letterIds: [1, 2, 3],
        isUnlocked: true,
        requiredPoints: 0,
      ),
      LandModel(
        id: 2,
        name: 'Magic Mountains',
        description: 'Discover new letters among the magical peaks',
        imagePath: 'assets/images/lands/magic_mountains.jpg',
        letterIds: [4, 5, 6],
        isUnlocked: false,
        requiredPoints: 30,
      ),
      LandModel(
        id: 3,
        name: 'Crystal Rivers',
        description: 'Follow the flowing waters to learn new sounds',
        imagePath: 'assets/images/lands/crystal_rivers.jpg',
        letterIds: [7, 8, 9],
        isUnlocked: false,
        requiredPoints: 70,
      ),
    ];
  }

  // Helper method to generate tracing points for letters
  List<Map<String, double>> _generateTracingPoints(String letter) {
    // In a real app, these would be carefully defined coordinates
    // for proper letter tracing paths
    switch (letter) {
      case 'A':
        return [
          {'x': 0.2, 'y': 0.8},
          {'x': 0.5, 'y': 0.2},
          {'x': 0.8, 'y': 0.8},
          {'x': 0.35, 'y': 0.5},
          {'x': 0.65, 'y': 0.5},
        ];
      case 'B':
        return [
          {'x': 0.2, 'y': 0.2},
          {'x': 0.2, 'y': 0.8},
          {'x': 0.2, 'y': 0.2},
          {'x': 0.6, 'y': 0.3},
          {'x': 0.7, 'y': 0.4},
          {'x': 0.6, 'y': 0.5},
          {'x': 0.2, 'y': 0.5},
          {'x': 0.6, 'y': 0.5},
          {'x': 0.7, 'y': 0.6},
          {'x': 0.7, 'y': 0.7},
          {'x': 0.6, 'y': 0.8},
          {'x': 0.2, 'y': 0.8},
        ];
      default:
        // Simple square for other letters
        return [
          {'x': 0.2, 'y': 0.2},
          {'x': 0.8, 'y': 0.2},
          {'x': 0.8, 'y': 0.8},
          {'x': 0.2, 'y': 0.8},
          {'x': 0.2, 'y': 0.2},
        ];
    }
  }
}