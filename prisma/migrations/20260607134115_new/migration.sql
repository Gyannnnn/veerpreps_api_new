/*
  Warnings:

  - You are about to drop the column `institute_id` on the `Branch` table. All the data in the column will be lost.
  - You are about to drop the column `institute_id` on the `User` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[instituteId,branchCode]` on the table `Branch` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[instituteId,name]` on the table `Branch` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[slug,instituteId]` on the table `Subject` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[subjectCode,instituteId]` on the table `Subject` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `instituteId` to the `Branch` table without a default value. This is not possible if the table is not empty.
  - Added the required column `createdBy` to the `Institute` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "InstituteStatus" AS ENUM ('pending', 'approved', 'rejected');

-- DropForeignKey
ALTER TABLE "Branch" DROP CONSTRAINT "Branch_institute_id_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReport" DROP CONSTRAINT "MaterialReport_materialId_fkey";

-- DropForeignKey
ALTER TABLE "MaterialReport" DROP CONSTRAINT "MaterialReport_reporterId_fkey";

-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_institute_id_fkey";

-- DropIndex
DROP INDEX "Branch_branchCode_key";

-- DropIndex
DROP INDEX "Branch_name_key";

-- DropIndex
DROP INDEX "Institute_name_key";

-- AlterTable
ALTER TABLE "Branch" DROP COLUMN "institute_id",
ADD COLUMN     "instituteId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Institute" ADD COLUMN     "approvedBy" TEXT,
ADD COLUMN     "createdBy" TEXT NOT NULL,
ADD COLUMN     "status" "InstituteStatus" NOT NULL DEFAULT 'pending';

-- AlterTable
ALTER TABLE "User" DROP COLUMN "institute_id",
ADD COLUMN     "instituteId" TEXT;

-- CreateTable
CREATE TABLE "InstituteReview" (
    "id" TEXT NOT NULL,
    "instituteId" TEXT NOT NULL,
    "reviewedById" TEXT NOT NULL,
    "status" "InstituteStatus" NOT NULL,
    "reason" TEXT NOT NULL,
    "reviewedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "InstituteReview_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Branch_instituteId_branchCode_key" ON "Branch"("instituteId", "branchCode");

-- CreateIndex
CREATE UNIQUE INDEX "Branch_instituteId_name_key" ON "Branch"("instituteId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Subject_slug_instituteId_key" ON "Subject"("slug", "instituteId");

-- CreateIndex
CREATE UNIQUE INDEX "Subject_subjectCode_instituteId_key" ON "Subject"("subjectCode", "instituteId");

-- AddForeignKey
ALTER TABLE "InstituteReview" ADD CONSTRAINT "InstituteReview_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "Institute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InstituteReview" ADD CONSTRAINT "InstituteReview_reviewedById_fkey" FOREIGN KEY ("reviewedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Branch" ADD CONSTRAINT "Branch_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "Institute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "Institute"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReport" ADD CONSTRAINT "MaterialReport_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReport" ADD CONSTRAINT "MaterialReport_materialId_fkey" FOREIGN KEY ("materialId") REFERENCES "StudyMaterial"("id") ON DELETE CASCADE ON UPDATE CASCADE;
