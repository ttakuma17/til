import { pgTable, varchar, serial } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'

export const customers = pgTable('customers', {
    id: serial('id').primaryKey(),
    name: varchar('name', { length: 32 }).notNull(),
    tel: varchar('tel', { length: 15 }).notNull(),
    ...schemaTimestamps
});