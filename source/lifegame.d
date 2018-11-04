class LifeGame {
    import std.stdio;
    import core.thread;
    import core.time : dur;

    alias Cells = bool[][];
    private int H = 30, W = 30;
    private Cells cells;
    int[][] livecell;

    this() {
        cells = new Cells(H, W);
        set_random();
        livecell = calc_livecell_num();
    }    

    this(int h, int w) {
        H = h; W = w;
        this();
    }

    void run() {
        while (true) {
            print();
            cells = update();
        }
    }

    private int[][] calc_livecell_num() {
        immutable int[][] ds = [
            [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]
        ];
        bool is_in(immutable int x, immutable int y) {
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
                write(cell ? "+" : ".");
            }
            writeln();
        }
        write("\r");
        stdout.flush();
        sleep(100);
        write("\033[2J"); // clean
    }

    private void set_cell(int x, int y) {
        cells[y][x] = true;
    }

    private void set_random() {
        import std.random : Random, uniform, unpredictableSeed;
        immutable int N = H * W - H - W;
        auto rnd = Random(unpredictableSeed);
        foreach (i; 0..N)
            set_cell(uniform(0, W, rnd), uniform(0, H, rnd));
    }

    private void sleep(immutable int msec) {
        Thread.sleep(dur!"msecs"(msec));
    }

    private Cells update() {
        int[][] nums = calc_livecell_num();
        Cells a = new Cells(H, W);
        foreach (y; 0..H) foreach (x; 0..W) {
            immutable int num = nums[y][x];
            if (!cells[y][x] && num == 3)                   // birth
                a[y][x] = true;
            else if (cells[y][x] && (num == 2 || num == 3)) // live
                a[y][x] = true;
            else if (cells[y][x] && num <= 1)               // underpopulation
                a[y][x] = false;
            else if (cells[y][x] && num >= 4)
                a[y][x] = false;                            // over 
        }
        return a;
    }
}
