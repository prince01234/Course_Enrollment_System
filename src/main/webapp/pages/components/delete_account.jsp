<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="delete-modal">
    <div class="delete-modal-content">
        <div class="delete-modal-header">
            <i class="fas fa-exclamation-triangle warning-icon"></i>
            <h3 id="deleteModalTitle">Confirm Deletion</h3>
        </div>
        <div class="delete-modal-body">
            <p id="deleteModalMessage">Are you sure you want to delete this item?</p>
            <p class="delete-warning">This action cannot be undone.</p>
        </div>
        <div class="delete-modal-footer">
            <button id="cancelDelete" class="btn-cancel">Cancel</button>
            <form id="deleteForm" action="" method="post" style="display:inline;">
                <input type="hidden" id="deleteItemId" name="userId" value="">
                <!-- Additional parameters can be added dynamically -->
                <div id="additionalParams"></div>
                <button type="submit" class="btn-delete" id="deleteButton">Delete</button>
            </form>
        </div>
    </div>
</div>

<!-- JavaScript for the delete modal -->
<script>
    // Initialize modal functionality when document is ready
    document.addEventListener('DOMContentLoaded', function() {
        // Set up cancel button
        const cancelBtn = document.getElementById('cancelDelete');
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                closeDeleteModal();
            });
        }
        
        // Close modal when clicking outside
        const modal = document.getElementById('deleteModal');
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeDeleteModal();
            }
        });
        
        // Close with ESC key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape' && modal && modal.style.display === 'block') {
                closeDeleteModal();
            }
        });
    });

    /**
     * Enhanced function to show delete modal with more options
     * @param {string|number} itemId - ID of the item to delete
     * @param {string} message - Custom message to display
     * @param {string} formAction - Form submission URL
     * @param {Object} options - Additional options
     */
    function showDeleteModal(itemId, message = null, formAction = null, options = {}) {
        const modal = document.getElementById('deleteModal');
        if (modal) {
            // Set custom message if provided
            if (message) {
                document.getElementById('deleteModalMessage').textContent = message;
            }
            
            // Set custom title if provided
            if (options.title) {
                document.getElementById('deleteModalTitle').textContent = options.title;
            }
            
            // Set the item ID to delete
            const deleteItemId = document.getElementById('deleteItemId');
            deleteItemId.value = itemId;
            
            // Set custom parameter name if provided (default is 'userId')
            if (options.paramName) {
                deleteItemId.name = options.paramName;
            } else {
                deleteItemId.name = 'userId';
            }
            
            // Set custom form action if provided
            if (formAction) {
                document.getElementById('deleteForm').action = formAction;
            } else {
                // Default to DeleteUserServlet
                document.getElementById('deleteForm').action = 
                    '<%= request.getContextPath() %>/DeleteUserServlet';
            }
            
            // Set custom button text if provided
            if (options.buttonText) {
                document.getElementById('deleteButton').textContent = options.buttonText;
            } else {
                document.getElementById('deleteButton').textContent = 'Delete';
            }
            
            // Clear any previous additional parameters
            const additionalParams = document.getElementById('additionalParams');
            additionalParams.innerHTML = '';
            
            // Add additional parameters if provided
            if (options.params && typeof options.params === 'object') {
                for (const [key, value] of Object.entries(options.params)) {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = value;
                    additionalParams.appendChild(input);
                }
            }
            
            // Special handling for account deletion
            if (options.isAccountDeletion) {
                const confirmInput = document.createElement('input');
                confirmInput.type = 'hidden';
                confirmInput.name = 'confirmDelete';
                confirmInput.value = 'true';
                additionalParams.appendChild(confirmInput);
            }
            
            // Show modal
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
    }

    // Function to close delete modal
    function closeDeleteModal() {
        const modal = document.getElementById('deleteModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
            
            // Reset form to default state
            setTimeout(() => {
                document.getElementById('deleteModalMessage').textContent = 
                    'Are you sure you want to delete this item?';
                document.getElementById('deleteItemId').value = '';
                document.getElementById('deleteModalTitle').textContent = 'Confirm Deletion';
                document.getElementById('deleteButton').textContent = 'Delete';
                document.getElementById('additionalParams').innerHTML = '';
            }, 300);
        }
    }
</script>