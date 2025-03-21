import { pgTable, varchar, serial } from 'drizzle-orm/pg-core';
import { schemaTimestamps } from './schemaBase'
import { createInsertSchema, createSelectSchema } from 'drizzle-zod';

export const customers = pgTable('customers', {
    id: serial('id').primaryKey(),
    name: varchar('name', { length: 32 }).notNull(),
    tel: varchar('tel', { length: 15 }).notNull(),
    ...schemaTimestamps
});

export const selectCustomerSchema = createSelectSchema(customers);
export const insertCustomerSchema = createInsertSchema(customers).omit({
    id: true,
    createdAt: true,
    updatedAt: true
});
