# PoC Weekend Project Brief: Performance Comparison of String Resources

**Objective:**  
The goal of this PoC project is to compare the performance of using traditional string resources in iOS (localizable.strings) versus using a database (SQLite) to host all the string resources. This comparison will help us justify whether migrating all string resources to a database impacts performance.

**Project Overview:**  
We will develop a simple app with a single screen that demonstrates the performance difference between the two methods of managing string resources.

**Features:**

1. **Initialize String Resources Database:**
   - Implement a function that initializes a database with 150 dummy string resources.
   - Use a for loop to insert these dummy strings into the database, ensuring each run rewrites the entire database.

2. **Hardcoded Native String Resources:**
   - Prepare 150 hardcoded string resources in localizable.strings (for iOS) as the baseline for native performance comparison.

3. **Performance Measurement:**
   - **Button 1:** Inflate all strings from the database into a TextView using a for loop, performing a query for each string, and record the time taken.
   - **Button 2:** Inflate all strings from the native string resources into a TextView using a for loop and record the time taken.
