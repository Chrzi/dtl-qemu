# Digitaltechnik Labor mit QEMU als Emulator auf Linux und Mac

Die bereitgestellte Umgebung des Digitallabor stellt einen Emulator für Windows bereit. Für MacOS und Linux besteht die Möglichkeit alle Aufgaben direkt auf der Platine laufen zu lassen.

Mit QEMU aber ist es auch möglich die meisten Aufgaben direkt auf dem PC zu debuggen.

Kenntnis des Terminals vorrausgesetzt.

## Installation

Es wird benötigt QEMU-ARM und die GNU ARM Crosscompile Toolchain

### MacOS

- Installiere brew von https://brew.sh das ist ein Paketmanager, mit dem wir die restlichen Sachen installieren im Terminal
- `brew install qemu`
- `brew install gcc-arm-none-eabi`

### Linux

Installiere `qemu-user-static`
- Ubuntu: `apt-get update`, `apt-get install qemu-user-static`
- ArchLinux: Aus dem AUR qemu-user-static oder qemu-user-static-bin

Installiere arm embedded toolchain
- Ubuntu: `apt-get install gcc-arm-none-eabi`
- ArchLinux: `pacman -S arm-none-eabi-gcc arm-none-eabi-gdb`

### Helfer-Skripte
Lade das Repository herunter und kopiere die beiden Skripte `assemble.sh` und `run.sh` in den workspace Ordner. Die Skripte sind ziemlich simpel und rufen im Prinzip nur den Compiler auf. `run.sh` macht etwas mehr und ruft zusätzlich qemu und gdb (den debugger) auf.

## Benutzung

Schreibe deinen Code in jedem möglichen Editor, beispielsweise VS Code oder Eclipse. Speicher und lass es mit run.sh laufen.

### assemble.sh und run.sh

Rufe das Skript mit der Datei auf die assemblen oder laufen lassen willst.
Beispiel: `./run.sh Aufgabe1/Aufgabe1_1.S`

assemble.sh baut die Datei und schreibt die Ausgabe in den Ordner "build" im workspace. Die Datei ohne Endung ist die lauffähige Binary (.elf auf Windows)

run.sh assembled, startet qemu und anschließend den CLI Debugger.

### gdb - Debugger 

`run.sh` ruft gdb auf und attached ihn gleich an qemu. gdb hat ein 3 Zeilen Layout, oben die Register, mittig der Code und unten ein Eingabefenster

- `n`/`next` springt ihr zeilenweise durchs Programm
- `c`/`continue` lässt das Programm bis zum nächsten Breakpoint laufen oder bis das Programm mit Ctrl-C unterbrochen wird
- `b <Zeile/Label>`/`break <Zeile/Label>` setzt einen Breakpoint an die gegebene Zeile oder an Label. Beispiel `b loop`
- `q`/`quit` beendet den Debugger und dabei wird der debuggte Prozess (qemu) ebenfalls beendet, was er sich bestätigen lässt.
- `Ctrl-x + S` wechselt in den "one key mode" (oder daraus heraus). Jeder Tastendruck wird direkt als Befehl interpretiert, Befehle mit Parametern beenden zur Eingabe den Modus kurzzeitig.
