import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get whatToWatch => 'What do you want to watch?';

  @override
  String get search => "Search";

  @override
  String get watchList => "Watch List";

  @override
  String get home => "Home";

  @override
  String get searchMovieTitle => "Find your movie by Type title, categories, years, etc";

  @override
  String get save => "Save";

  @override
  String get notFound =>  "We Are Sorry, We Can Not Find The Movie :(";

  @override
  String get detail => "Detail";

  @override
  String get noMovie => "There is no movie yet!";


}
