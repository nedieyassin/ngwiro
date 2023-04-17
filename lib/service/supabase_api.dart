import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {
  final supabase = Supabase.instance.client;

  Future<List?> getAgeGroups() async {
    return await supabase.from('age_groups').select('*').limit(100);
  }

  Future<List?> getGenders() async {
    return await supabase.from('genders').select('*').limit(100);
  }

  Future<List?> getAnswerOptions() async {
    return await supabase.from('answer_options').select('*').limit(100);
  }

  Future<List?> getArticles() async {
    return await supabase.from('articles').select('*').limit(100);
  }

  Future<List?> getDistricts() async {
    return await supabase.from('districts').select('*').limit(100);
  }

  Future<List?> getHealthCenters() async {
    return await supabase.from('health_centers').select('*,district(name)').limit(100);
  }

  Future<List?> getQuestions() async {
    return await supabase.from('questions').select('*').limit(100);
  }

  Future<List?> getScoreScales() async {
    return await supabase.from('score_scales').select('*').limit(100);
  }
}
