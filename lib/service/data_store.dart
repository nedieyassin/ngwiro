import 'package:hive_flutter/adapters.dart';
import 'package:ngwiro/service/supabase_api.dart';

class DataStore {
  Box dataCache = Hive.box('dataCache');
  Box stateCache = Hive.box('stateCache');

  SupabaseApi api = SupabaseApi();

  updateAllCache() {
    getAgeGroups();
    getGenders();
    getQuestions();
    getAnswerOptions();
    getArticles();
    getHealthCenters();
    getScoreScales();
    getDistricts();
  }

  clearAllCache() {
    dataCache.clear();
  }

  Future<void> acceptDisclaimer() {
    return stateCache.put('disclaimer', true);
  }

  Future<void>  userAge(int age) {
    return stateCache.put('user_age', age);
  }

  getUserAge() {
    return stateCache.get('user_age');
  }

  Future<void> userGender(int gender) {
    return stateCache.put('user_gender', gender);
  }

  getUserGender() {
    return stateCache.get('user_gender');
  }

  getDisclaimer() {
    return stateCache.get('disclaimer', defaultValue: false);
  }

  getAgeGroups() async {
    List? res = dataCache.get('age_groups');
    if (res == null) {
      res = await api.getAgeGroups();
      if (res != null) {
        dataCache.put('age_groups', res);
      }
    }
    return res;
  }

  getGenders() async {
    List? res = dataCache.get('genders');
    if (res == null) {
      res = await api.getGenders();
      if (res != null) {
        dataCache.put('genders', res);
      }
    }
    return res;
  }

  getAnswerOptions() async {
    List? res = dataCache.get('answer_options');
    if (res == null) {
      res = await api.getAnswerOptions();
      if (res != null) {
        dataCache.put('answer_options', res);
      }
    }
    return res;
  }

  getArticles() async {
    List? res = dataCache.get('articles');
    if (res == null) {
      res = await api.getArticles();
      // print(res);
      if (res != null) {
        dataCache.put('articles', res);
      }
    }
    return res;
  }

  getDistricts() async {
    List? res = dataCache.get('districts');
    if (res == null) {
      res = await api.getDistricts();
      if (res != null) {
        dataCache.put('districts', res);
      }
    }
    return res;
  }

  getHealthCenters() async {
    List? res = dataCache.get('health_centers');
    if (res == null) {
      res = await api.getHealthCenters();
      if (res != null) {
        dataCache.put('health_centers', res);
      }
    }
    return res;
  }

  getQuestions() async {
    List? res = dataCache.get('questions');
    if (res == null) {
      res = await api.getQuestions();
      // print(res);
      if (res != null) {
        dataCache.put('questions', res);
      }
    }
    return res;
  }

  getScoreScales() async {
    List? res = dataCache.get('score_scales');
    if (res == null) {
      res = await api.getScoreScales();
      if (res != null) {
        dataCache.put('score_scales', res);
      }
    }
    return res;
  }
}
