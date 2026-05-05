== Rust-программа для измерения времени компиляции

Для получения данных таблицы @tab:compilation_times была написана программа на языке Rust. Она запускает оба компилятора $n$ раз для документа заданного объёма, фиксирует времена выполнения и вычисляет среднее по формуле @eq:mean_time.

Центральная функция `benchmark_compilation` принимает команду запуска компилятора и число итераций. Вспомогательная функция `compute_mean` реализует формулу @eq:mean_time. Функция `main` обходит набор тестовых документов и выводит итоговую таблицу со значением коэффициента ускорения $S$ из формулы @eq:speedup.

Константа `N_RUNS` задаёт количество запусков компилятора на один документ; по умолчанию она равна `5`.

Ключевой фрагмент программы приведён ниже:

```rust
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
            return Err("Command failed".into());
        }
        times.push(elapsed);
    }
    Ok(times)
}
```

Полный листинг программы вынесен в приложение @app:rust_benchmark. Результирующие данные сохраняются в файл формата CSV и затем передаются сценарию генерации диаграмм.

== Анализ документа на Rust

В рамках работы также написан анализатор `.tex`-файлов на языке Rust. Программа подсчитывает количество слов, математических окружений и ссылок в исходном файле LaTeX. Поле `words` структуры `Stats` накапливает общее число слов, `envs` --- число окружений (`\begin{...}...\end{...}`), а `refs` --- число команд `\cite` и `\ref`.

Ниже показана ключевая часть программы:

```rust
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
```

Полный листинг программы на Rust приведён в приложении @app:rust_analyzer.

== Набор математических формул в Typst

Для сравнения ниже показан пример набора формул в Typst @typst-docs. Синтаксис математики в Typst более лаконичен: строчная формула заключается в одиночные знаки `$`, а выключная --- в знаки `$ ... $` с пробелами.

```typst
// Строчная формула
Среднее значение $ overline(T) = 1/n sum_(i=1)^n t_i $.

// Выключная формула (пробелы вокруг содержимого)
$ S = overline(T)_"LaTeX" / overline(T)_"Typst" $

// Полиномиальная зависимость
$ T_"LaTeX" (p) = alpha p^2 + beta p + gamma $
```

Pygments поддерживает подсветку Typst через `typst`-лексер; нативный лексер включён начиная с версии 2.18 @pygments.
