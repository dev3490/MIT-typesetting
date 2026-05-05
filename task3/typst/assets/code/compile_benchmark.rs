use std::fs::File;
use std::io::Write;
use std::path::Path;
use std::process::Command;
use std::time::Instant;

const N_RUNS: usize = 5;

struct DocSize {
    label: &'static str,
    latex: &'static str,
    typst: &'static str,
}

const DOCUMENT_SIZES: &[DocSize] = &[
    DocSize { label: "10pages", latex: "docs/latex_10.tex", typst: "docs/typst_10.typ" },
    DocSize { label: "50pages", latex: "docs/latex_50.tex", typst: "docs/typst_50.typ" },
    DocSize { label: "100pages", latex: "docs/latex_100.tex", typst: "docs/typst_100.typ" },
    DocSize { label: "250pages", latex: "docs/latex_250.tex", typst: "docs/typst_250.typ" },
    DocSize { label: "500pages", latex: "docs/latex_500.tex", typst: "docs/typst_500.typ" },
];

fn benchmark_compilation(command: &[&str], n: usize) -> Result<Vec<f64>, String> {
    let mut times = Vec::new();
    for _ in 0..n {
        let start = Instant::now();
        let output = Command::new(command[0])
            .args(&command[1..])
            .output()
            .map_err(|e| format!("Failed to execute command: {}", e))?;

        let elapsed = start.elapsed().as_secs_f64();
        if !output.status.success() {
            return Err(format!(
                "Command failed: {}\n{}",
                command.join(" "),
                String::from_utf8_lossy(&output.stderr)
            ));
        }
        times.push(elapsed);
    }
    Ok(times)
}

fn compute_mean(values: &[f64]) -> f64 {
    values.iter().sum::<f64>() / values.len() as f64
}

fn compute_speedup(latex_mean: f64, typst_mean: f64) -> f64 {
    latex_mean / typst_mean
}

fn main() {
    let mut results = Vec::new();

    for doc in DOCUMENT_SIZES {
        let latex_path = Path::new(doc.latex);
        let typst_path = Path::new(doc.typst);

        if !latex_path.exists() || !typst_path.exists() {
            eprintln!("Skipping {}: document files not found.", doc.label);
            continue;
        }

        println!("Benchmarking {}...", doc.label);

        let latex_cmd = ["pdflatex", "-interaction=nonstopmode", doc.latex];
        let typst_cmd = ["typst", "compile", doc.typst];

        let latex_times = benchmark_compilation(&latex_cmd, N_RUNS).expect("LaTeX benchmark failed");
        let typst_times = benchmark_compilation(&typst_cmd, N_RUNS).expect("Typst benchmark failed");

        let latex_mean = compute_mean(&latex_times);
        let typst_mean = compute_mean(&typst_times);
        let speedup = compute_speedup(latex_mean, typst_mean);

        results.push((doc.label, latex_mean, typst_mean, speedup));

        println!(
            "  LaTeX: {:.3}s  |  Typst: {:.3}s  |  Speedup: {:.1}x",
            latex_mean, typst_mean, speedup
        );
    }

    let output_file = "benchmark_results.csv";
    let mut f = File::create(output_file).expect("Could not create output file");
    writeln!(f, "label,latex_mean,typst_mean,speedup").unwrap();
    for (label, l_mean, t_mean, speedup) in results {
        writeln!(f, "{},{:.3},{:.3},{:.2}", label, l_mean, t_mean, speedup).unwrap();
    }

    println!("\nResults saved to {}", output_file);
}
