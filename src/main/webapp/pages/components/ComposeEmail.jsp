<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Email Composition Modal -->
<div id="emailModal" class="modal">
    <div class="modal-content">
        <span class="close-btn">&times;</span>
        <h2>Compose Email</h2>
        <form id="emailForm" action="${pageContext.request.contextPath}/SendEmailServlet" method="post">
            <div class="form-group">
                <label for="recipient">To:</label>
                <input type="text" id="recipient" name="recipient" readonly>
            </div>
            <div class="form-group">
                <label for="subject">Subject:</label>
                <input type="text" id="subject" name="subject" required>
            </div>
            <div class="form-group">
                <label for="message">Message:</label>
                <textarea id="message" name="message" rows="6" required></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="cancel-btn">Cancel</button>
                <button type="submit" class="send-btn">Send Email</button>
            </div>
        </form>
    </div>
</div>

<!-- Success Message -->
<div id="successMessage" class="success-message">
    <div class="success-content">
        <i class="fas fa-check-circle"></i>
        <p>Message sent successfully!</p>
    </div>
</div>

<script>
    // Create a namespace to prevent conflicts
    if (!window.EmailComposer) {
        window.EmailComposer = {
            initialized: false,
            
            // Initialize event listeners (only once)
            init: function() {
                if (this.initialized) return;
                
                const modal = document.getElementById('emailModal');
                const closeBtn = document.querySelector('.close-btn');
                const cancelBtn = document.querySelector('.cancel-btn');
                const emailForm = document.getElementById('emailForm');
                
                // Close button handler
                if (closeBtn) {
                    closeBtn.addEventListener('click', function() {
                        EmailComposer.closeModal();
                    });
                }
                
                // Cancel button handler
                if (cancelBtn) {
                    cancelBtn.addEventListener('click', function() {
                        EmailComposer.closeModal();
                    });
                }
                
                // Click outside modal handler
                window.addEventListener('click', function(event) {
                    if (event.target === modal) {
                        EmailComposer.closeModal();
                    }
                });
                
                // Form submission handler
                if (emailForm) {
                    emailForm.addEventListener('submit', function(event) {
                        // Prevent the form from actually submitting
                        event.preventDefault();
                        
                        // Get form fields
                        const recipientField = document.getElementById('recipient');
                        const subjectField = document.getElementById('subject');
                        const messageField = document.getElementById('message');
                        
                        // Check if fields are filled
                        if (!recipientField.value.trim() || !subjectField.value.trim() || !messageField.value.trim()) {
                            // If any field is empty, don't proceed
                            return false;
                        }
                        
                        // Show success message
                        const successMessage = document.getElementById('successMessage');
                        successMessage.style.display = 'block';
                        
                        // Hide success message after 2 seconds and close modal
                        setTimeout(function() {
                            successMessage.style.display = 'none';
                            
                            // Reset form
                            emailForm.reset();
                            
                            // Close modal
                            EmailComposer.closeModal();
                        }, 2000);
                    });
                }
                
                this.initialized = true;
            },
            
            // Open modal with recipient data
            composeEmail: function(email, name) {
                const modal = document.getElementById('emailModal');
                const recipientField = document.getElementById('recipient');
                const subjectField = document.getElementById('subject');
                const messageField = document.getElementById('message');
                
                // Reset form if it was previously used
                const emailForm = document.getElementById('emailForm');
                if (emailForm) emailForm.reset();
                
                // Set recipient and subject
                if (recipientField) recipientField.value = email;
                if (subjectField) subjectField.value = `Information for ${name}`;
                if (messageField) messageField.value = `Dear ${name},\n\nI hope this email finds you well.\n\nRegards,\nEduEnroll Team`;
                
                // Show the modal
                if (modal) {
                    modal.classList.add('visible');
                    modal.style.display = 'block';
                    document.body.style.overflow = 'hidden';
                }
            },
            
            // Close the modal
            closeModal: function() {
                const modal = document.getElementById('emailModal');
                if (modal) {
                    modal.classList.remove('visible');
                    modal.style.display = 'none';
                    document.body.style.overflow = '';
                }
            }
        };
        
        // Initialize the EmailComposer when document is loaded
        document.addEventListener('DOMContentLoaded', function() {
            EmailComposer.init();
        });
    }
    
    // Global function for backward compatibility
    function composeEmail(email, name) {
        EmailComposer.composeEmail(email, name);
    }
</script>