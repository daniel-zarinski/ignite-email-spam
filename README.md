# Installing Ollama

## Step 1: Download and Install.cl

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

## Step 4: Installing Visual Basic Script

### Step 1: Enable Developer Mode in Outlook

1. **Open Outlook.**
2. Go to **File > Options**.
3. In the **Outlook Options** window, click on **Customize Ribbon**.
4. On the right side, you'll see a list of Main Tabs. Check the box next to **Developer** to enable the Developer tab.
5. Click **OK** to save your settings. The Developer tab should now appear in the Outlook ribbon.

### Step 2: Access the VBA Editor

1. Go to the **Developer** tab in the Outlook ribbon.
2. Click on **Visual Basic** to open the VBA editor, or press `Alt + F11`.

### Step 3: Import the `.cls` File

1. In the VBA editor, go to **File > Import File**.
2. Navigate to the location of your `.cls` file.
3. Select the `.cls` file and click **Open**. This will add the class module to your VBA project.

### Step 4: Check the Imported Class Module

1. After importing, you should see the new class module listed under the "Class Modules" folder in the **Project Explorer**.
2. Double-click on the class module to view its contents.
3. Copy the contents of that file to your ThisOutlookSession
4. Delete ThisOutlookSession1 by right clicking it -> remove.

### Step 5: Configure email

1. `Update the userMailbox = "user@example.com" ' Replace with the actual email address`

### Step 5: Save the Project

1. Once the class module is imported, save your project by going to **File > Save**.

# Configuration

## Modelfile

The modelfile contains the system message that the local LLM will use.

- Replace `PERSON_NAME` with the full name of the person. Note this appears a few times.
- Replace `JOB_TITLE` with the job title

Run the below command to update the LLM.

```PowerShell
ollama create email-spam-ollama3.1 -f .\Modelfile
```

## Visual Basic Script

Replace the following line:
`userMailbox = "user@example.com" ' Replace with the actual email address`

# EXPLAIN TOOL SETUP
