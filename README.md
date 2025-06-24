# Allamvizsga-2025

Futtatáshoz szükséges szoftverek:
- PostgreSQL v14+
- .NET 7 SDK
- Flutter SDK
- fizikai eszköz vagy Android Emulator.
Ajánlott környezet: VS Code / Android Studio + Flutter Plugin, PgAdmin

Futtatás lépései:
- szerver és adatbázis létrehozása a PgAdmin felületen
- dotnet/appsettings.json: connection string megadása
- terminálból (pl. VS Code): cd src/dotnet -> dotnet ef database update -> dotnet run
- lib/responsive/constants fileban beállítani a BASE_URL-t a lokális IP címre amin az alkalmazás fog futni
- fizikai eszköz (Android) csatlakoztatása USB-n keresztül vagy emulátor használata
- egy másik terminálból a frontend futtatása: cd fitness_app -> flutter pub get -> flutter run

Projekt téma: FitTrack - fitness alkalmazás

Fontosabb funkcionalitások:
  - új felhasználó regisztrálása/bejelentkezés
  - különböző típusú edzések követése, információk eltárolása:
      - időtartam
      - megtett távolság
      - átlagsebesség
      - elégetett kalóriák
  - egyéni célok beállítása és nyomon követése
  - teljesített célok alapján kialakított heatmap
  - lépésszámláló
  - ismerősök/más felhasználók követése
  - napi bevitt kalóriák követése (étkezések elmentése)
  - chatbot: edzéstervek és diéták ajánlása
  - edzés rutin kialakítása, felhasználó emlékeztetése

Használt technológiák:
  - Frontend:
      - Flutter: UI kivitelezése
  - Backend:
    - PostgreSQL
    - .NET
    - C#
