# International STEM Master's ROI Analysis

Which study-abroad destination pays back an international master's degree
fastest? This project answers that for six countries and two data
occupations, using each country's own labor-market and tuition data.

---

## Quick start

- Results: open `ROI_Analysis.xlsx`. Every sheet is pre-calculated with
  live formulas.
- SQL pipeline: see `/sql`. Run `staging` then `analysis` against the CSVs
  in `/data`.
- Full write-up: methodology, findings, and limitations are below.

---

## Scope

- Population: international (non-EU / non-domestic) students
- Degree level: master's
- Countries: United States, Canada, United Kingdom, Australia, Germany,
  Netherlands
- Occupations: Data Analyst, Data Scientist
- Programs sampled: 10 per country (60 total). These are popular,
  standard choices open to international students, not only top-ranked
  universities.
- Financial ROI only. Quality of life and other subjective factors were
  left out to keep the analysis defensible and small enough to finish as
  a first portfolio project.

BI Analyst was considered as a third occupation and dropped: distinct
wage data isn't available for all six countries. Keeping it would have
meant either duplicating the Data Scientist numbers under a new label or
mixing government and non-government sources inconsistently across
occupations.

---

## Methodology

### Tuition and living costs

Collected per program from official university sources and converted to
total program cost in USD, not per-year figures. Summarized with median
and IQR rather than averages, because a handful of programs in each
country cost far more than the rest and would drag an average upward.

### Salary

Entry-level salary is defined per country, using whichever concept that
country's own labor data actually supports, rather than forcing a single
definition like "25th percentile" onto countries that don't publish it:

| Country | Entry-level definition | Source |
|---|---|---|
| United States | 25th percentile wage | BLS OEWS (May 2025) |
| Canada | Job Bank "Low" wage | Job Bank / Government of Canada |
| United Kingdom | Home Office "new entrant" rate | gov.uk Skilled Worker visa going rates (ASHE-derived) |
| Germany | Lower quartile | Entgeltatlas, Bundesagentur für Arbeit (2025) |
| Australia | Graduate / entry-level, two sources by role | Hays Australia salary guide (Data Analyst); aggregated recruitment guide (Data Scientist). Non-government, see Limitations |
| Netherlands | Junior (0-2 yrs) salary | Nationale Beroepengids. Non-government, see Limitations |

Tax covers federal/national tax plus mandatory payroll contributions
only (FICA in the US, CPP/EI in Canada, National Insurance in the UK).
State and provincial tax is excluded wherever it varies a lot by region,
since the sampled programs are spread across many regions and one
regional rate would misrepresent the country.

### ROI formulas

Two metrics are computed for every program x occupation pair.

Payback period, in years:

```
Basic payback      = Total tuition / Annual net salary
Realistic payback  = (Total tuition + Total living cost) / Annual net salary
```

Cumulative ROI at 5 and 10 years post-graduation:

```
N-year ROI = ((N x Annual net salary) - Total investment) / Total investment x 100
```

With 10 programs per country, results are reported as a median plus the
25th-75th percentile range rather than one country average, so the
spread shows how much the outcome depends on which program a student
picks.

### Employment rate, dropped

An employment-rate multiplier on expected earnings was planned, then
dropped when the data proved impossible to source consistently. The U.S.
has no government study of international-student outcomes comparable to
Canada's StatCan National Graduates Survey, and the available figures
mixed incompatible populations (international vs. domestic, STEM vs. all
fields). Forcing those numbers in would have been worse than documenting
the gap. Payback and ROI figures therefore assume continuous employment
in the target occupation from graduation onward.

---

## Findings

Ranked by median realistic payback period, fastest first:

| Rank | Country | Realistic payback (median) |
|---|---|---|
| 1 | Germany | ~0.65-0.73 years |
| 2 | Canada | ~1.37-1.62 years |
| 3 | Netherlands | ~1.65-1.94 years |
| 4 | United Kingdom | ~1.80-2.45 years |
| 5 | United States | ~2.10-2.54 years |
| 6 | Australia | ~2.64-2.86 years |

Occupation carries nearly as much weight as country. Data Scientist beats
Data Analyst on payback speed and 10-year ROI in all six countries,
typically by 3-6 months of payback and 100-200 percentage points of
10-year ROI.

Germany's lead comes from tuition policy, not pay. Its entry-level
salaries sit mid-pack; the free-tuition policy at several public
universities produces the result.

Program choice swings the answer far more in some countries than others.
The gap between a country's fastest and slowest sampled program runs from
under two months (UK, Germany) to nearly ten months (Netherlands).

Ten-year ROI widens these gaps: Germany at roughly 1,280-1,440% against
Australia at 250-280%. That reflects a persistent cost-to-earnings
difference rather than a one-time head start, though Germany's percentage
should be read against the near-zero denominator noted below.

---

## Data limitations

Read these before citing any single number.

**Germany's near-zero tuition.** Seven of Germany's ten sampled programs
charge $0, which is real German public-university policy, not missing
data. Basic payback collapses toward zero and 10-year ROI% inflates into
four digits. The arithmetic is right, but it reflects a tiny denominator
rather than a degree that is "10x better." Realistic payback, which
includes living costs, is the fairer comparison for Germany.

**Australia's salary figures come from two private sources**, where the
other five countries each use one. An earlier single-source version (SEEK
Grad) showed identical pay for both roles, which no other country's data
did. Australian entry-level Data Scientist estimates turned out to vary
from roughly AUD $57,000 to $140,000 across sources, a wider spread than
anywhere else here. The current figures (Hays for Data Analyst, an
aggregated recruitment guide for Data Scientist) are more credible but
still less certain than the rest. Government sources (ABS, Jobs and
Skills Australia) were tried first; wage data was suppressed or
unpublished for these occupation codes.

**Netherlands salary and tax are estimates**, not primary-sourced. CBS
publishes wage data by sector and CAO, not by occupation title, so there
is no government wage-lookup tool equivalent to the other five. Salary
comes from a private careers-guidance site, and the tax rate is
interpolated after a conflicting calculator proved unreliable. See the
notes in `Graduate_outcomes.xlsx`.

**Employment rate is not modeled**, as described above.

**Salaries are held flat** across the payback and ROI horizon, with no
assumed raises. This makes payback periods conservative, slightly longer
than reality.

**Opportunity cost is excluded.** Income forgone while studying isn't
counted in total investment. Adding it would push payback later,
especially for two-year programs, and is the obvious next version.

---

## Repository structure

```
├── README.md
├── data/
│   ├── tuition_data.csv
│   └── salary_data.csv
├── sql/
│   ├── staging/
│   │   └── 01_create_and_validate_staging.sql
│   └── analysis/
│       ├── 02_roi_calculations.sql
│       ├── 03_summary_median_iqr.sql
│       └── 04_rankings_window_functions.sql
├── Master_Tuition_Table.xlsx      (source data + validation notes)
├── Graduate_outcomes.xlsx         (salary/tax data + per-row sourcing)
└── ROI_Analysis.xlsx              (full analysis in Excel, live formulas)
```

## Reproducing the analysis

**Excel.** Open `ROI_Analysis.xlsx`. All four sheets (Tuition_Data,
Salary_Data, ROI_Calculations, Summary) run on live formulas, so editing
the source data recalculates everything downstream.

**SQL / Databricks.**

1. Upload `data/tuition_data.csv` and `data/salary_data.csv` as tables
   named `tuition_data` and `salary_data` (Catalog → Create table →
   Upload file).
2. Run the scripts in order: `01_create_and_validate_staging.sql` →
   `02_roi_calculations.sql` → `03_summary_median_iqr.sql` →
   `04_rankings_window_functions.sql`.
3. Scripts `03` and `04` create the `roi_calculations` and `roi_summary`
   views that the dashboard is built on.

**Dashboard.** Built in Databricks AI/BI Dashboards on the `roi_summary`
view: payback comparison, investment-vs-salary scatter, and program
spread charts.

---

## License

MIT. Reuse the methodology or the code freely. The underlying salary and
tuition figures reflect specific years' sourcing and should be
re-verified before anyone uses them for a real decision.
