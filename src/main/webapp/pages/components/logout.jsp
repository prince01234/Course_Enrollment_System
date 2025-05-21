<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Logout Modal -->
<div id="logoutModal" class="logout-modal">
    <div class="logout-modal-content">
        <div class="logout-modal-header">
            <h3>Confirm Logout</h3>
        </div>
        <div class="logout-modal-body">
            <p>Are you sure you want to logout from EduEnroll?</p>
        </div>
        <div class="logout-modal-footer">
            <button id="cancelLogout" class="btn-cancel">Cancel</button>
            <form action="<%= request.getContextPath() %>/LogoutServlet" method="post" style="display:inline;">
                <button type="submit" class="btn-logout">Logout</button>
            </form>
        </div>
    </div>
</div>

<!-- JavaScript for the logout modal -->
<script>
    // Initialize modal functionality when document is ready
    document.addEventListener('DOMContentLoaded', function() {
        // Set up cancel button
        const cancelBtn = document.getElementById('cancelLogout');
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                closeLogoutModal();
            });
        }
        
        // Close modal when clicking outside
        const modal = document.getElementById('logoutModal');
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeLogoutModal();
            }
        });
        
        // Close with ESC key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape' && modal && modal.style.display === 'block') {
                closeLogoutModal();
            }
        });
    });

    // Function to show logout modal
    function showLogoutModal() {
        const modal = document.getElementById('logoutModal');
        if (modal) {
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
    }

    // Function to close logout modal
    function closeLogoutModal() {
        const modal = document.getElementById('logoutModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
        }
    }
</script>