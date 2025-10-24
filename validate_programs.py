#!/usr/bin/env python3
"""
Validation script for programs.json
Ensures all programs meet the requirements specified in the problem statement.
"""

import json
import sys
import os

# Valid task types
VALID_TASK_TYPES = ['reading', 'quiz', 'project']

def validate_programs():
    """Validate the programs.json file structure and content."""
    
    # Support running from project root or from script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, 'assets', 'data', 'programs.json')
    
    if not os.path.exists(json_path):
        print(f"❌ Error: programs.json not found at {json_path}")
        return False
    
    with open(json_path, 'r') as f:
        programs = json.load(f)
    
    # Expected programs with their week counts
    expected_programs = {
        'ai_ml': 8,
        'web_dev': 8,
        'cybersecurity': 6,
        'mobile_dev': 6,
        'data_analytics': 6
    }
    
    print("🔍 Validating programs.json...")
    print(f"Found {len(programs)} programs\n")
    
    errors = []
    
    # Check we have exactly 5 programs
    if len(programs) != 5:
        errors.append(f"Expected 5 programs, found {len(programs)}")
    
    for program in programs:
        program_id = program.get('id', 'UNKNOWN')
        print(f"📚 Program: {program.get('title', 'UNKNOWN')} (ID: {program_id})")
        
        # Validate required fields
        required_fields = ['id', 'title', 'description', 'duration', 'level', 'learning', 'modules']
        for field in required_fields:
            if field not in program:
                errors.append(f"Program {program_id} missing required field: {field}")
        
        # Validate ID matches expected
        if program_id not in expected_programs:
            errors.append(f"Unexpected program ID: {program_id}")
        
        # Validate week count
        modules = program.get('modules', [])
        expected_weeks = expected_programs.get(program_id, 0)
        
        if len(modules) != expected_weeks:
            errors.append(f"Program {program_id} should have {expected_weeks} weeks, has {len(modules)}")
        
        print(f"  ✓ Duration: {program.get('duration', 'N/A')}")
        print(f"  ✓ Level: {program.get('level', 'N/A')}")
        print(f"  ✓ Modules: {len(modules)} weeks")
        
        # Validate each module
        for idx, module in enumerate(modules, 1):
            if 'week' not in module:
                errors.append(f"Program {program_id}, module {idx} missing 'week' field")
            if 'title' not in module:
                errors.append(f"Program {program_id}, module {idx} missing 'title' field")
            if 'tasks' not in module:
                errors.append(f"Program {program_id}, module {idx} missing 'tasks' field")
            
            tasks = module.get('tasks', [])
            # Each week should have tasks
            if len(tasks) == 0:
                errors.append(f"Program {program_id}, week {idx} has no tasks")
            
            # Validate task types
            for task in tasks:
                task_type = task.get('type', '')
                if task_type not in VALID_TASK_TYPES:
                    errors.append(f"Program {program_id}, invalid task type: {task_type}")
        
        print(f"  ✓ Total tasks: {sum(len(m.get('tasks', [])) for m in modules)}")
        print()
    
    # Report results
    print("=" * 60)
    if errors:
        print("❌ VALIDATION FAILED\n")
        print("Errors found:")
        for error in errors:
            print(f"  - {error}")
        return False
    else:
        print("✅ VALIDATION PASSED")
        print("\nAll programs are correctly structured:")
        print("  • 5 programs total")
        print("  • AI & ML: 8 weeks")
        print("  • Web Dev: 8 weeks")
        print("  • Cybersecurity: 6 weeks")
        print("  • Mobile Dev: 6 weeks")
        print("  • Data Analytics: 6 weeks")
        print("  • All tasks have valid types (reading/quiz/project)")
        return True

if __name__ == '__main__':
    success = validate_programs()
    sys.exit(0 if success else 1)
