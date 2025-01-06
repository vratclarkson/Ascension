import Foundation
import CoreData

// MARK: - Core Data Model Conversions

// MARK: - Summit Conversions
extension Summit {
    func toEntity(context: NSManagedObjectContext) -> SummitEntity {
        let entity = SummitEntity(context: context)
        entity.id = id
        entity.title = title
        entity.desc = description
        entity.image = image
        
        // Create pillar entities
        let pillarEntities = pillars.map { pillar in
            let pillarEntity = pillar.toEntity(context: context)
            pillarEntity.summit = entity
            return pillarEntity
        }
        entity.pillars = NSSet(array: pillarEntities)
        
        return entity
    }
}

extension SummitEntity {
    func toModel() -> Summit {
        Summit(
            id: id ?? UUID(),
            title: title ?? "",
            description: desc ?? "",
            image: image ?? "",
            pillars: pillarsArray.map { $0.toModel() }
        )
    }
}

// MARK: - Pillar Conversions
extension Pillar {
    func toEntity(context: NSManagedObjectContext) -> PillarEntity {
        let entity = PillarEntity(context: context)
        entity.id = id
        entity.title = title
        entity.desc = description
        entity.timeline = Int32(timeline)
        
        // Create metric entities
        let metricEntities = metrics.map { metric in
            let metricEntity = metric.toEntity(context: context)
            metricEntity.pillar = entity
            return metricEntity
        }
        entity.metrics = NSSet(array: metricEntities)
        
        // Create ascent entities
        let ascentEntities = ascents.map { ascent in
            let ascentEntity = ascent.toEntity(context: context)
            ascentEntity.pillar = entity
            return ascentEntity
        }
        entity.ascents = NSSet(array: ascentEntities)
        
        return entity
    }
}

extension PillarEntity {
    func toModel() -> Pillar {
        Pillar(
            id: id ?? UUID(),
            title: title ?? "",
            description: desc ?? "",
            metrics: metricsArray.map { $0.toModel() },
            timeline: Int(timeline),
            ascents: ascentsArray.map { $0.toModel() }
        )
    }
}

// MARK: - Metric Conversions
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
}

extension MetricEntity {
    func toModel() -> Metric {
        Metric(
            id: id ?? UUID(),
            name: name ?? "",
            targetValue: targetValue,
            currentValue: currentValue,
            unit: unit ?? ""
        )
    }
}

// MARK: - Ascent Conversions
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
        let basecampEntities = basecamps.map { basecamp in
            let basecampEntity = basecamp.toEntity(context: context)
            basecampEntity.ascent = entity
            return basecampEntity
        }
        entity.basecamps = NSSet(array: basecampEntities)
        
        return entity
    }
}

extension AscentEntity {
    func toModel() -> Ascent {
        Ascent(
            id: id ?? UUID(),
            title: title ?? "",
            description: desc ?? "",
            timeframe: TimeFrame(rawValue: timeframe ?? "") ?? .yearly,
            startDate: startDate ?? Date(),
            endDate: endDate ?? Date(),
            basecamps: basecampsArray.map { $0.toModel() }
        )
    }
}

// MARK: - Basecamp Conversions
extension Basecamp {
    func toEntity(context: NSManagedObjectContext) -> BasecampEntity {
        let entity = BasecampEntity(context: context)
        entity.id = id
        entity.title = title
        entity.isCompleted = isCompleted
        entity.dueDate = dueDate
        return entity
    }
}

extension BasecampEntity {
    func toModel() -> Basecamp {
        Basecamp(
            id: id ?? UUID(),
            title: title ?? "",
            isCompleted: isCompleted,
            dueDate: dueDate ?? Date()
        )
    }
}
