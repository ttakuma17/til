import { pgTable, serial, integer, varchar, timestamp, index } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'

export const options = pgTable('options', {
    id: serial('id').primaryKey(),
    name: varchar('name').notNull(),
    value: varchar('value').notNull(),
    ...schemaTimestamps
});
