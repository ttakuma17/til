CREATE TABLE "customers" (
	"id" serial PRIMARY KEY NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	"name" varchar(32) NOT NULL,
	"tel" varchar(15) NOT NULL
);
