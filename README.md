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

Installiere `qemu-system-arm`
- Ubuntu: `apt-get update`, `apt-get install qemu-system-arm`
- ArchLinux: `pacman -S qemu-arch-extra`

Installiere arm embedded toolchain
- Ubuntu: `apt-get install gcc-arm-none-eabi gdb-multiarch`
- ArchLinux: `pacman -S arm-none-eabi-gcc arm-none-eabi-gdb`

### Helfer-Skripte
Lade das Repository herunter und kopiere die beiden Skripte `assemble.sh` und `run.sh` in den workspace Ordner. Die Skripte sollen euch etwas Arbeit abnehmen und das assemblen und starten des Debuggers beschleunigen. Der Output der Skripte ist standardmäßig im `workspace/build`.

## Benutzung

Schreibe deinen Code in jedem möglichen Editor, beispielsweise VS Code oder Eclipse. Speicher und lass es mit run.sh laufen.

### assemble.sh und run.sh

Rufe das Skript mit der Datei auf die assemblen oder laufen lassen willst.
Beispiel: `./run.sh Aufgabe1/Aufgabe1_1.S`

assemble.sh baut die Datei und schreibt die Ausgabe in den Ordner "build" im workspace. Die Datei ohne Endung ist die lauffähige Binary (.elf auf Windows)

run.sh assembled, startet qemu und anschließend den CLI Debugger.

#### Stack Pointer

Da QEMU nicht genau exakt die CPU und Board aus dem Labor emuliert, benutzen die Skripte eine ähnliche CPU.
Diese hat aber eine andere Memory-Map. Was heißt das? Im Prinzip nur dass der RAM an einer anderen Adresse liegt.

Standardmäßig wird die initale Stack-Pointer Adresse `0x40001000` durch die für die QEMU-CPU passende Adresse `0x04001000` ersetzt.
Dies geschieht beim assemblen und nicht in der Original Datei, sie kann also normal abgegeben werden.
Mit der Option `-m` kann dies ausgeschaltet werden

### gdb - Debugger 

`run.sh` ruft gdb auf und attached ihn gleich an qemu. gdb hat ein 3 Zeilen Layout, oben die Register, mittig der Code und unten ein Eingabefenster

- `n`/`next` führt die aktuelle Anweisung aus, "step over", `bl` ist ein Befehl und man springt nicht "hinein" (step-over)
- `s`/`step` führt zeilenweise aus, "step into", folgt `bl`
- `c`/`continue` lässt das Programm bis zum nächsten Breakpoint laufen oder bis das Programm mit Ctrl-C unterbrochen wird
- `b <Zeile/Label>`/`break <Zeile/Label>` setzt einen Breakpoint an die gegebene Zeile oder an Label. Beispiel `b loop`
- `q`/`quit` beendet den Debugger und dabei wird der debuggte Prozess (qemu) ebenfalls beendet, was er sich bestätigen lässt.
- `Ctrl-x + S` wechselt in den "one key mode" (oder daraus heraus). Jeder Tastendruck wird direkt als Befehl interpretiert, Befehle mit Parametern beenden zur Eingabe den Modus kurzzeitig.
