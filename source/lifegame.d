import std.stdio;

//
// update() : セルを次の世代にアップデートする
class LifeGame {
    alias Cells = bool[][];
    private int H = 20, W = 20;
    private Cells cells;
    int[][] livecell;

    this() {
        cells = new Cells(H, W);
        set_all();
        livecell = calc_livecell_num();
    }    

    this(int h, int w) {
        H = h; W = w;
        this();
    }


    void run() {
    }

    private int[][] calc_livecell_num() {
        immutable int[][] ds = [
            [1, 0],
            [1, 1],
            [0, 1],
            [-1, 1],
            [-1, 0],
            [-1, -1],
            [0, -1],
            [1, -1]
        ];
        bool is_in(int x, int y) {
            return (0<=x && x<W && 0<=y && y<H);
        }
        int[][] a = new int[][](H, W);
        foreach (immutable y; 0..H) foreach (immutable x; 0..W) {
            foreach (d; ds) {
                immutable int nx = x + d[0];
                immutable int ny = y + d[1];
                if (!is_in(nx, ny)) continue;
                if (cells[ny][nx])
                    a[y][x]++; 
            }
        }
        return a;
    }

    private void print() {
        foreach (line; cells) {
            foreach (cell; line) {
                write(cell ? 1 : 0);
            }
            writeln();
        }
    }

    private void set_cell(int x, int y) {
        cells[y][x] = true;
    }

    void set_all() {
        set_cell(0, 0);
        set_cell(0, 1);
        set_cell(1, 0);
    }

    static int add(int x, int y) {
        return x + y;
    }

    unittest {
        assert(add(0,0) == 0);
    }
}

unittest {
    LifeGame lg = new LifeGame(10, 10);
    lg.run();
}
