# Task Management App User Manual (Version 2)

## Introduction
Welcome to the Task Management App (Version 2)! This version introduces enhanced functionality, including advanced reporting and time analysis features. Use this guide to explore and maximize the app's capabilities.

---

## Installation
### Prerequisites
- Ensure Flutter is installed on your system.
- Verify the Flutter installation:
  ```bash
  flutter doctor
  ```

### Installation Steps
1. Clone the updated repository:
    ```bash
    git clone <repository_url>
    ```
2. Navigate to the project directory:
    ```bash
    cd <project_directory>
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Launch the app:
    ```bash
    flutter run
    ```

---

## Features

### 1. **Time Entry Management**
- Navigate to the "Add Entry" screen via the floating action button.
- Fill in task details, including:
  - Task name
  - Date
  - Start and end time
  - Tag (optional)
- Tap "Save" to create a time entry.
- Edit or delete existing entries via the "Query Result" screen.

---

### 2. **Query Time Usage**
- Open the "Query Input" screen.
- Choose a query type:
  - **By Date:** Find entries for a specific date.
  - **By Task:** Retrieve entries for a particular task.
  - **By Tag:** Search entries based on tags.
- Enter the query details and tap "Search."
- View and manage the results on the "Query Result" screen.

---

### 3. **Generate Time Usage Reports**
- Navigate to the "Reports" screen.
- Select a date range using the date picker.
- Tap "Generate Report" to fetch all entries within the selected range.
- View grouped and sorted results, including:
  - List of tasks with start and end times.
  - Total time tracked for the selected period.
  - Count of distinct tasks.

---

### 4. **Analyze Time Allocation**
- Open the "Time Analysis" screen from the floating action button.
- Select the analysis type:
  - **By Task:** Rank tasks based on total time spent.
  - **By Tag:** Categorize and analyze time allocation by tags.
- View:
  - Ranked lists of tasks or tags with total hours.
  - Visualizations like pie charts for a detailed breakdown.
- Use the scrollable legend to identify chart sections.

---

### 5. **Enhanced UI/UX**
- Enjoy a cleaner, more modern interface.
- Access advanced features via a dynamic floating action button.
- Switch between analysis modes effortlessly with dropdown menus.

---

## Best Practices
- Regularly update task tags for more accurate analysis.
- Use meaningful task names for easier searching and querying.
- Utilize the "Analyze Time" feature to identify productivity patterns.

---

## Troubleshooting
### Issue: App Does Not Run
1. Ensure Flutter is installed and configured properly.
2. Verify dependencies are installed:
    ```bash
    flutter pub get
    ```
3. Check for errors in the terminal during `flutter run`.

### Issue: Data Not Displaying
- Confirm entries exist for the queried date or task.
- Ensure correct format for date and time fields.
