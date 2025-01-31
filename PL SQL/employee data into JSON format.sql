DECLARE
	-- Declare a CLOB variable to hold the JSON output
    l_json CLOB;  
BEGIN
    -- Create a JSON array of departments, each containing an array of employees
    SELECT json_arrayagg(
               json_object(
                   'job' VALUE NVL(department_name, 'Employee without department'),  -- Use 'Employee without department' if department_name is NULL
                   'employee' VALUE json_arrayagg(
                       json_object(
                           'id' VALUE employee_id,
                           'name' VALUE first_name
                       )
                   )
               )
           ) INTO l_json
    FROM hr.employees e
    LEFT JOIN hr.departments d ON e.department_id = d.department_id
    GROUP BY department_name;

    -- Output the generated JSON string
    DBMS_OUTPUT.PUT_LINE(l_json);

END;