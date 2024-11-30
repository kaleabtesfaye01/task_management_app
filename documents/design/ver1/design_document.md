### **Overview**
This app is a time management tool that allows users, primarily students, to record, track, and analyze their time usage through intuitive interfaces for adding, querying, and managing time entries. It aims to improve productivity and time awareness.

---

### **Pages**

#### **Home Page**
* Displays all recorded time entries in a list view.
  * Each entry shows the task name, date, time (from-to), and tag.
* Include an **'Add'** button to navigate to the Entry Input Page for recording new time entries.
* Include a **'Search'** button to navigate to the Query Entry Page for searching existing time entries.
* Entries can be edited or deleted directly from this page via action buttons (e.g., **Edit**, **Delete**) displayed alongside each entry.

#### **Entry Input Page**
* **Inputs:**
  * Text field for the **task name**.
  * Date picker for selecting the **date** (default to today's date).
  * Two time pickers for recording the **from** and **to** times.
  * Text field for adding a **tag** to the entry.
* Validation:
  * Ensure start time is earlier than end time.
  * Warn users if a new entry overlaps with an existing one.
* **Save** Button:
  * Save the entry to the Firebase database.
  * Display a confirmation message upon successful save.
* **Cancel** Button:
  * Navigate back to the Home Page without saving.

#### **Query Entry Page**
* **Inputs:**
  * Dropdown menu for selecting the search criterion: **Date**, **Task Name**, or **Tag**.
    * For **Date**, include a date picker (default to today's date).
    * For **Task Name**, include a text field to enter keywords.
    * For **Tag**, include a text field to search by specific tags.
* **Search** Button:
  * Execute the query and display matching entries in a list view.
* **Reset** Button:
  * Clear all filters and return to the full list of entries.

---

### **Key Functionalities**

#### **Recording Time Usage**
* Flexible input formats for dates and times:
  * Allow users to input dates in various formats (e.g., `MM/DD/YYYY`, `YYYY-MM-DD`).
  * Accept both 12-hour (with AM/PM) and 24-hour formats for times.
* Automatically calculate and display the total duration for each time entry (e.g., `2 hrs 30 mins`).


#### **Saving and Storing Data**
* All time entries are stored in a **Firebase database** with the following fields:
  * `id`: Unique identifier for each entry.
  * `date`: Date of the task.
  * `task`: Task name or description.
  * `fromTime`: Start time.
  * `toTime`: End time.
  * `tag`: Tag categorizing the task.
* Ensure data consistency with basic validation before saving.
* Confirmation message includes task name and date for user clarity.


#### **Querying Time Usage**
* Results are displayed in a paginated list view to handle large datasets.
* Highlight key search terms in the results to help users quickly identify relevant entries.


#### **Editing and Deleting Time Entries**
* Edit:
  * Allow users to update any field of an entry and save changes.
  * Provide feedback if editing causes overlaps or conflicts with existing entries.
* Delete:
  * Ask for confirmation before deleting an entry to prevent accidental loss.