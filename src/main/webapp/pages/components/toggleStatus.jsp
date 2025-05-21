<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Custom Status Confirmation Modal -->
<div id="statusConfirmModal">
    <div class="status-modal-content">
        <div class="status-modal-header">
            <h3><i class="fas fa-question-circle"></i> Confirm Status Change</h3>
            <span class="close" onclick="closeStatusModal()">&times;</span>
        </div>
        <div class="status-modal-body">
            <p id="statusConfirmMessage"></p>
        </div>
        <div class="status-modal-footer">
            <button id="statusCancelBtn" class="status-cancel-btn" onclick="cancelStatusChange()">Cancel</button>
            <button id="statusConfirmBtn" class="status-confirm-btn">Confirm</button>
        </div>
    </div>
</div>

<script>
// Variables to store the pending status change
let pendingCourseId = null;
let pendingIsActive = null;

// Function to show the status confirmation modal
function showStatusModal(courseId, isActive) {
    pendingCourseId = courseId;
    pendingIsActive = isActive;
    
    const message = `Are you sure you want to ${isActive ? 'activate' : 'deactivate'} this course?`;
    document.getElementById('statusConfirmMessage').textContent = message;
    
    document.getElementById('statusConfirmModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

// Function to close the status confirmation modal
function closeStatusModal() {
    document.getElementById('statusConfirmModal').style.display = 'none';
    document.body.style.overflow = 'auto';
    
    // If we're closing without confirming, revert the checkbox
    if (pendingCourseId !== null) {
        revertCheckbox();
    }
    
    // Reset pending values
    pendingCourseId = null;
    pendingIsActive = null;
}

// Function to handle cancel button click
function cancelStatusChange() {
    // Revert checkbox and close modal
    revertCheckbox();
    closeStatusModal();
}

// Function to revert checkbox state
function revertCheckbox() {
    if (pendingCourseId !== null && pendingIsActive !== null) {
        try {
            const checkbox = document.querySelector(`.course-item[data-course-id="${pendingCourseId}"] .toggle-switch input`);
            if (checkbox) {
                checkbox.checked = !pendingIsActive;
            } else {
                console.error("Could not find checkbox element for course ID:", pendingCourseId);
            }
        } catch (e) {
            console.error("Error reverting checkbox state:", e);
        }
    }
}

// Function to confirm status change
function confirmStatusChange() {
    if (pendingCourseId === null || pendingIsActive === null) {
        console.error("No pending status change to confirm");
        return;
    }
    
    // Close the modal
    document.getElementById('statusConfirmModal').style.display = 'none';
    document.body.style.overflow = 'auto';
    
    // Show loading spinner
    showSpinner();
    
    // Redirect to servlet
    window.location.href = contextPath + "/ToggleCourseStatusServlet?courseId=" + pendingCourseId;
}

// Function to toggle course status
function toggleCourseStatus(courseId, isActive) {
    // Show custom confirmation modal
    showStatusModal(courseId, isActive);
}

// Setup event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    // Setup confirm button for status modal
    document.getElementById('statusConfirmBtn').addEventListener('click', function() {
        confirmStatusChange();
    });
    
    // Close when clicking outside status confirm modal
    window.addEventListener('click', function(event) {
        const statusConfirmModal = document.getElementById('statusConfirmModal');
        if (event.target === statusConfirmModal) {
            closeStatusModal();
        }
    });
});
</script>