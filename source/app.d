import std.stdio;
import lifegame;

void main(string[] args) {
    writeln("done");
}

unittest {
    LifeGame lg = new LifeGame(10, 10);
    lg.run();
}
