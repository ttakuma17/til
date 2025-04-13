import { pgTable, serial, integer, varchar, timestamp, index } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'

export const campaigns = pgTable('campaigns', {
    id: serial('id').primaryKey(),
    name: varchar('name').notNull(),
    campaignType: varchar('campaign_type').notNull(),
    discount: integer('discount').notNull(),
    campaignStart: timestamp('campaignStart').notNull(),
    campaignEnd: timestamp('campaignEnd').notNull(),
    ...schemaTimestamps
});
