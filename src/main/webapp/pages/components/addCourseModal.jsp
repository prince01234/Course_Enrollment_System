<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Add Course Modal -->
<div id="addCourseModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-plus-circle"></i> Add New Course</h2>
            <span class="close">&times;</span>
        </div>
        <form id="addCourseForm" action="<%= request.getContextPath() %>/AddCourseServlet" method="POST">
            <div class="form-grid">
                <div class="form-group">
                    <label for="courseTitle"><i class="fas fa-bookmark"></i> Course Title</label>
                    <input type="text" id="courseTitle" name="courseTitle" placeholder="Enter course title" required>
                </div>
                
                <div class="form-group">
                    <label for="courseLevel"><i class="fas fa-layer-group"></i> Course Level</label>
                    <select id="courseLevel" name="courseLevel" required>
                        <option value="BEGINNER">Beginner</option>
                        <option value="INTERMEDIATE">Intermediate</option>
                        <option value="ADVANCED">Advanced</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="duration"><i class="fas fa-calendar-week"></i> Duration (weeks)</label>
                    <input type="number" id="duration" name="duration" min="1" placeholder="e.g. 8" required>
                </div>

                <div class="form-group">
                    <label for="credits"><i class="fas fa-award"></i> Credit Hours</label>
                    <input type="number" id="credits" name="credits" min="1" placeholder="e.g. 3" required>
                </div>

                <div class="form-group">
                    <label for="minStudents"><i class="fas fa-user-friends"></i> Minimum Students</label>
                    <input type="number" id="minStudents" name="minStudents" min="1" placeholder="e.g. 10" required>
                </div>

                <div class="form-group">
                    <label for="maxStudents"><i class="fas fa-users"></i> Maximum Students</label>
                    <input type="number" id="maxStudents" name="maxStudents" min="1" placeholder="e.g. 30" required>
                </div>

                <div class="form-group">
                    <label for="cost"><i class="fas fa-dollar-sign"></i> Course Cost</label>
                    <input type="number" id="cost" name="cost" min="0" step="0.01" placeholder="e.g. 299.99" required>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-toggle-on"></i> Course Status</label>
                    <div style="display: flex; align-items: center; margin-top: 8px;">
                        <label class="toggle-switch" style="margin-right: 10px;">
                            <input type="checkbox" id="isOpen" name="isOpen" checked>
                            <span class="slider round"></span>
                        </label>
                        <span id="openStatus">Active</span>
                    </div>
                </div>
                
                <!-- Hidden field to store current user's ID as instructor -->
                <input type="hidden" name="instructorId" value="${sessionScope.user.userId}">

                <div class="form-group full-width">
                    <label for="description"><i class="fas fa-align-left"></i> Course Description</label>
                    <textarea id="description" name="description" rows="4" 
                        placeholder="Enter a detailed description of the course content and objectives" required></textarea>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i> Create Course
                </button>
                <button type="button" class="btn-secondary" onclick="closeModal()">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        </form>
    </div>
</div>