# webODV Oxygen Significance Analysis

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24112289.svg)](https://doi.org/10.5281/zenodo.24112289)

R analysis of dissolved oxygen observations (bottle) from the Hawaii Ocean Time-series (HOT) program, using
two small subsets exported from [HOT-webODV](https://hot.webodv.awi.de/): **1999–2000** and
**2019–2020**.

The script estimates short-lag autocorrelation with the Edelson–Krolik discrete correlation function
(DCF), calculates an approximate effective sample size using an AR(1) formula, and compares the two
period means using a Welch t-test.

## Data and usage

- `oxygen_bottle_hot_1999_2000.txt`: HOT oxygen observations, 1999–2000.
- `oxygen_bottle_hot_2019_2020.txt`: HOT oxygen observations, 2019–2020.

Each text file contains two whitespace-separated columns: decimal year and oxygen measurement. They
are **selected subsets**, not the full HOT dataset.

From the repository directory, run in R:

```r
source("oxygen_autocorrelation_welch.r")
```

Update the filenames in the script if necessary.

**Statistical limitation:** The AR(1) effective-sample-size formula assumes regular sampling; here a
DCF estimate from irregularly sampled observations is substituted as an approximation. The adjusted
Welch test is therefore a sensitivity analysis, not an exact autocorrelation-aware significance
test.

## Data provenance and acknowledgement

Original observations: [Hawaii Ocean Time-series (HOT)](https://hahana.soest.hawaii.edu/hot/). Data
subsets exported using [HOT-webODV](https://hot.webodv.awi.de/). Please cite and acknowledge HOT and
the webODV service when using these data. See [DATA_LICENSE.md](DATA_LICENSE.md) for provenance and
reuse notes.

## Citation and licensing

Use [CITATION.cff](CITATION.cff) to cite the analysis software. The author's R code is distributed
under the [MIT License](LICENSE). **The MIT license does not cover the two HOT data subsets**; the
original provider's conditions apply (see [DATA_LICENSE.md](DATA_LICENSE.md)).
