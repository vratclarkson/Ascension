import Foundation
import CoreData

// MARK: - Core Data Helpers
extension Summit {
    func toEntity(context: NSManagedObjectContext) -> SummitEntity {
        let entity = SummitEntity(context: context)
        entity.id = id
        entity.title = title
        entity.desc = description
        entity.image = image
        
        // Create pillar entities
        pillars.forEach { pillar in
            let pillarEntity = pillar.toEntity(context: context)
            pillarEntity.summit = entity
        }
        
        return entity
    }
    
    static func fromEntity(_ entity: SummitEntity) -> Summit {
        Summit(
            title: entity.title ?? "",
            description: entity.desc ?? "",
            image: entity.image ?? "",
            pillars: (entity.pillars?.allObjects as? [PillarEntity])?.map(Pillar.fromEntity) ?? []
        )
    }
}

extension Pillar {
    func toEntity(context: NSManagedObjectContext) -> PillarEntity {
        let entity = PillarEntity(context: context)
        entity.id = id
        entity.title = title
        entity.desc = description
        entity.timeline = Int32(timeline)
        
        // Create metric entities
        metrics.forEach { metric in
            let metricEntity = metric.toEntity(context: context)
            metricEntity.pillar = entity
        }
        
        // Create ascent entities
        ascents.forEach { ascent in
            let ascentEntity = ascent.toEntity(context: context)
            ascentEntity.pillar = entity
        }
        
        return entity
    }
    
    static func fromEntity(_ entity: PillarEntity) -> Pillar {
        Pillar(
            title: entity.title ?? "",
            description: entity.desc ?? "",
            metrics: (entity.metrics?.allObjects as? [MetricEntity])?.map(Metric.fromEntity) ?? [],
            timeline: Int(entity.timeline),
            ascents: (entity.ascents?.allObjects as? [AscentEntity])?.map(Ascent.fromEntity) ?? []
        )
    }
}

extension Metric {
    func toEntity(context: NSManagedObjectContext) -> MetricEntity {
        let entity = MetricEntity(context: context)
        entity.id = id
        entity.name = name
        entity.targetValue = targetValue
        entity.currentValue = currentValue
        entity.unit = unit
        return entity
    }
    
    static func fromEntity(_ entity: MetricEntity) -> Metric {
        Metric(
            name: entity.name ?? "",
            targetValue: entity.targetValue,
            currentValue: entity.currentValue,
            unit: entity.unit ?? ""
        )
    }
}

extension Ascent {
    func toEntity(context: NSManagedObjectContext) -> AscentEntity {
        let entity = AscentEntity(context: context)
        entity.id = id
        entity.title = title
        entity.desc = description
        entity.timeframe = timeframe.rawValue
        entity.startDate = startDate
        entity.endDate = endDate
        
        // Create basecamp entities
        basecamps.forEach { basecamp in
            let basecampEntity = basecamp.toEntity(context: context)
            basecampEntity.ascent = entity
        }
        
        return entity
    }
    
    static func fromEntity(_ entity: AscentEntity) -> Ascent {
        Ascent(
            title: entity.title ?? "",
            description: entity.desc ?? "",
            timeframe: TimeFrame(rawValue: entity.timeframe ?? "") ?? .yearly,
            startDate: entity.startDate ?? Date(),
            endDate: entity.endDate ?? Date(),
            basecamps: (entity.basecamps?.allObjects as? [BasecampEntity])?.map(Basecamp.fromEntity) ?? []
        )
    }
}

extension Basecamp {
    func toEntity(context: NSManagedObjectContext) -> BasecampEntity {
        let entity = BasecampEntity(context: context)
        entity.id = id
        entity.title = title
        entity.isCompleted = isCompleted
        entity.dueDate = dueDate
        return entity
    }
    
    static func fromEntity(_ entity: BasecampEntity) -> Basecamp {
        Basecamp(
            title: entity.title ?? "",
            isCompleted: entity.isCompleted,
            dueDate: entity.dueDate ?? Date()
        )
    }
}

// End of file. No additional code.
