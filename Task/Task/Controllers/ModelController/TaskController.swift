//
//  TaskController.swift
//  Task
//
//  Created by Kelsey Sparkman on 4/21/21.
//

import Foundation

class TaskController {
    
    static let shared = TaskController()
    var tasks: [Task] = []
    
    // MARK: - CRUD
    func createTaskWith(name: String, notes: String?, dueDate: Date?) {
        let newTask = Task(name: name, notes: notes, dueDate: dueDate)
        tasks.append(newTask)
        saveToPersistentStorage(tasks: tasks)
    }
    
    func update(task: Task, name: String, notes: String?, dueDate: Date?) {
        task.name = name
        task.notes = notes
        task.dueDate = dueDate
        saveToPersistentStorage(tasks: tasks)
    }
    
    func toggleIsComplete(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStorage(tasks: tasks)
    }
    
    func delete(task: Task) {
        guard let index = tasks.firstIndex(of: task) else {return}
        tasks.remove(at: index)
        saveToPersistentStorage(tasks: tasks)
    }
    
    // MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0].appendingPathComponent("Task.json")
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage(tasks: [Task]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(tasks)
            try data.write(to: fileURL())
        } catch let error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try jsonDecoder.decode([Task].self, from: data)
            self.tasks = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
    

}
