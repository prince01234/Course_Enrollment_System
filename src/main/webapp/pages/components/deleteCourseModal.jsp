<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="modal">
    <div class="modal-content" style="max-width: 500px;">
        <div class="modal-header" style="background-color: #ffebee;">
            <h2><i class="fas fa-exclamation-triangle" style="color: #e53935;"></i> Delete Course</h2>
            <span class="close" onclick="closeDeleteModal()">&times;</span>
        </div>
        <form id="deleteForm" action="<%= request.getContextPath() %>/DeleteCourseServlet" method="POST">
            <input type="hidden" id="courseIdToDelete" name="courseId" value="">
            <div style="padding: 20px;">
                <p id="deleteConfirmText">Are you sure you want to delete this course?</p>
                <div class="form-actions">
                    <button type="submit" class="btn-primary" style="background-color: #e53935;">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                    <button type="button" class="btn-secondary" onclick="closeDeleteModal()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>