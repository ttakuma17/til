import { timestamp } from 'drizzle-orm/pg-core';

const timestamps = {
    createdAt: timestamp('created_at').notNull().defaultNow(),
    updatedAt: timestamp('updated_at').notNull().defaultNow(),
};

export const schemaTimestamps = {
    ...timestamps,
};

