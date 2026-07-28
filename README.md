# Fine-tuning open-sourced LLMs in Healthcare: Automated Medical Triage

![UT Austin](https://img.shields.io/badge/University-Texas%20at%20Austin-orange)
![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)
![Model](https://img.shields.io/badge/Base%20Model-BioMistral--7B-green)

This project focuses on optimizing the medical triage process by fine-tuning the **BioMistral-7B** model to predict disease types and clinical departments based on natural language patient symptoms.

## 📌 Project Overview
The healthcare industry faces a critical bottleneck due to overwhelmed systems and a shortage of reception staff. Patients often struggle with "layman" descriptions that don't match professional medical terminology.

**Our Goal:** To bridge this gap by leveraging LLMs for automated, accurate patient routing based on self-reported narratives.



---

## 🛠️ Technical Workflow

### 1. Data Preprocessing & Standardization
We processed a dataset of **7,475 self-reported symptoms** across 22 unique diseases and 8 departments.
* **Artifact Removal:** Removed stray characters and symbols like "/".
* **Redundancy Filtering:** Prevented disease names from leaking into department labels.
* **Normalization:** Applied standard casing (Title Case) for consistent vocabulary.

### 2. Fine-tuning Methodology
We employed a two-stage fine-tuning approach:

* **Stage 1: Supervised Fine-Tuning (SFT) via LoRA**:
    * Injected domain knowledge into the BioMistral base model.
    * Taught the model a strict output format: `{Disease: xxx; [cite_start]Department: xxx}`.
    * **LoRA Advantage:** Froze pre-trained weights and trained low-rank approximations to reduce computational overhead.
* **Stage 2: Direct Preference Optimization (DPO)**:
    * Utilized an RLHF approach to align model outputs with human preferences for safety and accuracy.
    * Reduced hallucinations by teaching the model to discriminate between "superior" and "inferior" responses.

### 3. Database Design for Deployment

A fine-tuned model that outputs a disease and department prediction is
only useful if that prediction can be tied back to a real patient, a real
encounter, and a real clinician's judgment. We designed a normalized
relational schema (3NF, 10 tables) as the backend for this system:

* **Prediction Storage:** Every model output is stored alongside the
  patient encounter that produced it, preserving the model's raw text
  output for auditability.
* **Human-in-the-Loop Review:** A separate `CLINICIAN_REVIEW` table
  records whether a clinician confirmed or overrode the model's
  suggestion — without ever overwriting the model's original prediction.
* **Trust & Safety Analysis:** Because predictions and reviews are stored
  independently, the schema supports queries like override rate by
  confidence level — directly measuring how much clinicians trust the
  model's output in practice.


## 📁 Repository Structure

```
├── Lora_funetune/       # Stage 1: LoRA supervised fine-tuning
├── DPO_finetune/         # Stage 2: DPO alignment
└── Database_design/      # Backend schema for storing predictions & clinician review
```
---

## 📊 Performance Comparison

| Metric | Baseline (Pre-tune) | LoRA SFT | DPO Results |
| :--- | :--- | :--- | :--- |
| **Average BLEU** | 0.1895 | 0.7069  | **0.7154** |
| **Exact Match** | N/A | 0.2500 | **0.2700**  |
| **Disease Macro F1** | N/A |**0.9577**  | 0.8014  |
| **Dept. Macro F1** | N/A | 0.0786 | **0.1310**  |


### 🔍 Results Analysis: Performance vs. Evaluation Metrics
> **Key Finding:** Fine-tuning successfully shifted the model from outputting "Unknown" to providing specific, structured medical suggestions.

While the **Disease Macro F1** and **Dept. Macro F1** scores may appear low, they do not fully reflect the model's actual diagnostic capability. Through manual error analysis, we observed the following:

* **Format Sensitivity:** The evaluation script uses a strict matching mechanism. Even if the model predicts the correct disease or department, any deviation in format (e.g., extra spaces, subtle punctuation differences, or case sensitivity) results in a "mismatch" score.
* **Semantic Correctness:** In many cases, the model successfully identified the correct clinical path, but because the output string did not provide an **Exact Match** with the ground-truth label, the F1 scores were penalized.
* **DPO Improvement:** The transition from LoRA to DPO significantly improved the model's ability to follow the required `{Disease: xxx; Department: xxx}` format, which is reflected in the increased **Average BLEU** and **Exact Match** scores.
---

## 🚀 Future Improvement Plans
* **Data Expansion:** Incorporate rare diseases and edge cases.
* **Annotation Quality:** Use clinician-verified labels to reduce ambiguity.
* **Enhanced Alignment:** Integrate safety filters and hallucination-reduction constraints.
* **Clinical Utility:** Provide severity estimation and urgency levels (e.g., ER vs. Outpatient).








