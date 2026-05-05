use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader};

#[derive(Default)]
struct Stats {
    words: usize,
    envs: usize,
    refs: usize,
}

fn count_pattern(line: &str, pattern: &str) -> usize {
    line.matches(pattern).count()
}

fn analyze_file(filename: &str, stats: &mut Stats) -> io::Result<()> {
    let file = File::open(filename)?;
    let reader = BufReader::new(file);

    for line in reader.lines() {
        let line = line?;
        stats.words += line.split_whitespace().count();
        stats.envs += count_pattern(&line, "\\begin{");
        stats.refs += count_pattern(&line, "\\cite{");
        stats.refs += count_pattern(&line, "\\ref{");
    }
    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <file.tex> [file.tex ...]", args[0]);
        std::process::exit(1);
    }

    let mut total = Stats::default();

    for filename in &args[1..] {
        let mut file_stats = Stats::default();
        if let Err(_) = analyze_file(filename, &mut file_stats) {
            eprintln!("Error: cannot open {}", filename);
            continue;
        }
        println!("{}:\n  words        : {}\n  environments : {}\n  references   : {}", 
                 filename, file_stats.words, file_stats.envs, file_stats.refs);

        total.words += file_stats.words;
        total.envs += file_stats.envs;
        total.refs += file_stats.refs;
    }

    if args.len() > 2 {
        println!("\nTotal:\n  words        : {}\n  environments : {}\n  references   : {}", 
                 total.words, total.envs, total.refs);
    }
}
