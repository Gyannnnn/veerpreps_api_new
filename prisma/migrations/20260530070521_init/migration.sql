/*
  Warnings:

  - Added the required column `institute_id` to the `User` table without a default value. This is not possible if the table is not empty.
  - Made the column `name` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "Users" AS ENUM ('admin', 'teacher', 'student');

-- CreateEnum
CREATE TYPE "YearOfTeaching" AS ENUM ('first_year', 'second_year', 'third_year', 'fourth_year', 'fifth_year', 'sixth_year', 'seventh_year', 'eighth_year');

-- CreateEnum
CREATE TYPE "materialType" AS ENUM ('pyq', 'notes', 'syllabus', 'assignment', 'lab_record');

-- CreateEnum
CREATE TYPE "MaterialStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "visibility" AS ENUM ('public', 'private', 'unlisted');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "avatar" TEXT,
ADD COLUMN     "branchId" TEXT,
ADD COLUMN     "deletedAt" TIMESTAMP(3),
ADD COLUMN     "faceBookLink" TEXT,
ADD COLUMN     "githubLink" TEXT,
ADD COLUMN     "instgramLink" TEXT,
ADD COLUMN     "institute_id" TEXT NOT NULL,
ADD COLUMN     "isDeleted" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "linkedInLink" TEXT,
ADD COLUMN     "userType" "Users" NOT NULL DEFAULT 'student',
ADD COLUMN     "verified" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "websiteLink" TEXT,
ADD COLUMN     "year" "YearOfTeaching",
ALTER COLUMN "password" DROP NOT NULL,
ALTER COLUMN "name" SET NOT NULL;

-- CreateTable
CREATE TABLE "Institute" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "logo" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "about" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT NOT NULL,

    CONSTRAINT "Institute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Branch" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "branchCode" TEXT NOT NULL,
    "institute_id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT NOT NULL,

    CONSTRAINT "Branch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subject" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "subjectCode" TEXT NOT NULL,
    "semester" INTEGER NOT NULL,
    "yearOfTeaching" "YearOfTeaching" NOT NULL,
    "slug" TEXT NOT NULL,
    "instituteId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" TEXT NOT NULL,

    CONSTRAINT "Subject_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BranchSubject" (
    "id" TEXT NOT NULL,
    "branchId" TEXT NOT NULL,
    "subjectId" TEXT NOT NULL,

    CONSTRAINT "BranchSubject_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserBucket" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "visibility" "visibility" NOT NULL,
    "views" INTEGER NOT NULL DEFAULT 0,
    "likesCount" INTEGER NOT NULL DEFAULT 0,
    "creatorId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "UserBucket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BucketMaterial" (
    "id" TEXT NOT NULL,
    "bucketId" TEXT NOT NULL,
    "studyMaterialId" TEXT NOT NULL,
    "addedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BucketMaterial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StudyMaterial" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "materialType" NOT NULL,
    "link" TEXT NOT NULL,
    "subjectId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "likes" INTEGER NOT NULL DEFAULT 0,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" TEXT,
    "uploaderId" TEXT NOT NULL,
    "status" "MaterialStatus" NOT NULL DEFAULT 'pending',
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "deletedAt" TIMESTAMP(3),
    "downloadCount" INTEGER NOT NULL DEFAULT 0,
    "fileHash" TEXT NOT NULL,
    "mimeType" TEXT,
    "fileSize" INTEGER,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StudyMaterial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialReport" (
    "id" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "reporterId" TEXT NOT NULL,
    "materialId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MaterialReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedMaterial" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "studyMaterialId" TEXT NOT NULL,
    "savedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedMaterial_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Institute_name_key" ON "Institute"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Institute_slug_key" ON "Institute"("slug");

-- CreateIndex
CREATE INDEX "Institute_logo_name_idx" ON "Institute"("logo", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Branch_name_key" ON "Branch"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Branch_branchCode_key" ON "Branch"("branchCode");

-- CreateIndex
CREATE INDEX "Branch_name_branchCode_idx" ON "Branch"("name", "branchCode");

-- CreateIndex
CREATE INDEX "Subject_name_semester_yearOfTeaching_idx" ON "Subject"("name", "semester", "yearOfTeaching");

-- CreateIndex
CREATE UNIQUE INDEX "Subject_name_instituteId_semester_key" ON "Subject"("name", "instituteId", "semester");

-- CreateIndex
CREATE INDEX "BranchSubject_branchId_subjectId_idx" ON "BranchSubject"("branchId", "subjectId");

-- CreateIndex
CREATE UNIQUE INDEX "BranchSubject_branchId_subjectId_key" ON "BranchSubject"("branchId", "subjectId");

-- CreateIndex
CREATE UNIQUE INDEX "UserBucket_slug_key" ON "UserBucket"("slug");

-- CreateIndex
CREATE INDEX "UserBucket_title_visibility_creatorId_likesCount_idx" ON "UserBucket"("title", "visibility", "creatorId", "likesCount");

-- CreateIndex
CREATE INDEX "BucketMaterial_studyMaterialId_idx" ON "BucketMaterial"("studyMaterialId");

-- CreateIndex
CREATE UNIQUE INDEX "BucketMaterial_bucketId_studyMaterialId_key" ON "BucketMaterial"("bucketId", "studyMaterialId");

-- CreateIndex
CREATE UNIQUE INDEX "StudyMaterial_fileHash_key" ON "StudyMaterial"("fileHash");

-- CreateIndex
CREATE INDEX "StudyMaterial_subjectId_type_year_idx" ON "StudyMaterial"("subjectId", "type", "year");

-- CreateIndex
CREATE INDEX "StudyMaterial_uploadedAt_idx" ON "StudyMaterial"("uploadedAt");

-- CreateIndex
CREATE INDEX "StudyMaterial_name_idx" ON "StudyMaterial"("name");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialReport_reporterId_materialId_key" ON "MaterialReport"("reporterId", "materialId");

-- CreateIndex
CREATE INDEX "SavedMaterial_studyMaterialId_idx" ON "SavedMaterial"("studyMaterialId");

-- CreateIndex
CREATE INDEX "SavedMaterial_userId_studyMaterialId_idx" ON "SavedMaterial"("userId", "studyMaterialId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedMaterial_userId_studyMaterialId_key" ON "SavedMaterial"("userId", "studyMaterialId");

-- CreateIndex
CREATE INDEX "User_name_year_idx" ON "User"("name", "year");

-- AddForeignKey
ALTER TABLE "Branch" ADD CONSTRAINT "Branch_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "Institute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subject" ADD CONSTRAINT "Subject_instituteId_fkey" FOREIGN KEY ("instituteId") REFERENCES "Institute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BranchSubject" ADD CONSTRAINT "BranchSubject_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "Branch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BranchSubject" ADD CONSTRAINT "BranchSubject_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "Subject"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "Branch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_institute_id_fkey" FOREIGN KEY ("institute_id") REFERENCES "Institute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserBucket" ADD CONSTRAINT "UserBucket_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BucketMaterial" ADD CONSTRAINT "BucketMaterial_bucketId_fkey" FOREIGN KEY ("bucketId") REFERENCES "UserBucket"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BucketMaterial" ADD CONSTRAINT "BucketMaterial_studyMaterialId_fkey" FOREIGN KEY ("studyMaterialId") REFERENCES "StudyMaterial"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudyMaterial" ADD CONSTRAINT "StudyMaterial_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "Subject"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudyMaterial" ADD CONSTRAINT "StudyMaterial_uploaderId_fkey" FOREIGN KEY ("uploaderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReport" ADD CONSTRAINT "MaterialReport_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MaterialReport" ADD CONSTRAINT "MaterialReport_materialId_fkey" FOREIGN KEY ("materialId") REFERENCES "StudyMaterial"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedMaterial" ADD CONSTRAINT "SavedMaterial_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedMaterial" ADD CONSTRAINT "SavedMaterial_studyMaterialId_fkey" FOREIGN KEY ("studyMaterialId") REFERENCES "StudyMaterial"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
