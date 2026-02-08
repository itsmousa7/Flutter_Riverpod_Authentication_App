import 'package:supabase_flutter/supabase_flutter.dart';

final userCollection = Supabase.instance.client.from('app_users');
final supabase = Supabase.instance.client;
final sbAuth = Supabase.instance.client.auth;