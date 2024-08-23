# Installing Ollama

## Step 1: Download and Install

- [Windows Installation](https://ollama.com/download/windows)
- [MacOS Installation](https://ollama.com/download/mac)
- [Linux Installation](https://ollama.com/download/linux)

## Step 2: Add Custom Email Spam Model

```PowerShell
ollama create email-spam-ollama3.1 -f .\Modelfile
```

## Step 3: Running Custom Model

```PowerShell
ollama run email-spam-ollama3.1
```

# Configuration

## Modelfile

The modelfile contains the system message that the local LLM will use.

- Replace `PERSON_NAME` with the full name of the person. Note this appears a few times.
- Replace `JOB_TITLE` with the job title
