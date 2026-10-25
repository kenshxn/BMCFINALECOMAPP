class AppConfig {
  // Public client credentials from the existing starter project. Override with
  // --dart-define for another Supabase project. Never put the service key here.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xxmusyjhfyqqilxrzqte.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4bXVzeWpoZnlxcWlseHJ6cXRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIzNTE3NDQsImV4cCI6MjEwNzkyNzc0NH0.9aoS6YAbqbqtjY9PE-ufXVAV2N6xgiAsBtI62OsIgLA',
  );
  static bool get isConfigured =>
      supabaseUrl.startsWith('https://') && supabaseAnonKey.isNotEmpty;
}
