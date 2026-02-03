# Fine-tuning open-sourced LLMs in Healthcare: Automated Medical Triage

This project focuses on optimizing medical triage by fine-tuning a Large Language Model (LLM) to predict disease types and clinical departments based on patient self-reported symptoms.

📌 Project Overview

The healthcare system faces a significant bottleneck due to a shortage of reception staff and long wait times. Patients often struggle to translate "layman" descriptions of symptoms into professional medical terminology, leading to confusion when selecting which department to visit.

Our Solution: Leveraging LLMs for automated, accurate patient routing.

Input: Patient's self-reported symptoms in natural language.

Output: Predicted Disease and Target Department (e.g., Disease: Tinnitus; Department: Otolaryngology).

🛠️ Methodology

1. Base Model

We utilized BioMistral-7B as our foundational model for domain-specific healthcare performance.


2. Fine-tuning Stages

Stage 1: Supervised Fine-Tuning (SFT) with LoRA.

Injected domain knowledge.

Trained the model to output a specific structured format: {Disease: xxx; Department: xxx}.

Used Low-Rank Adaptation (LoRA) to freeze pre-trained weights and train low-rank approximations, ensuring efficiency.


Stage 2: Direct Preference Optimization (DPO).

Aligned the model with human preferences for accuracy and safety.

Reduced hallucinations by teaching the model to discriminate between "superior" and "inferior" outputs.

3. Data Preprocessing

We processed 7,475 self-reported symptoms covering 22 unique diseases and 8 departments.



Artifact Removal: Cleaned stray characters and symbols (e.g., "/").


Redundancy Filter: Prevented disease names from leaking into department labels.



Standardization: Applied title casing for consistent vocabulary.

📊 Performance & Results

Metric,Baseline Test ,LoRA SFT ,DPO Results 
Average BLEU,0.1895,0.7069,0.7154
Exact Match Accuracy,-,0.2500,0.2700
Disease Macro F1,-,0.9577,0.8014
Department Macro F1,-,0.0786,0.1310



Key Observation: Before fine-tuning, the model often outputted "Unknown" for complex symptoms. Post-fine-tuning, the model consistently generates responses with reasonable accuracy and professional structure.

🚀 Improvement Plans



Expand Data: Incorporate rare diseases and edge cases.



Annotation Quality: Use clinician-verified labels to reduce ambiguity.



Enhanced Alignment: Integrate safety filters for high-risk symptoms.



Deployment: Build a user-friendly triage assistant interface and integrate into EHR systems.
