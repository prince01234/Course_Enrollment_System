<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<% 
    // Get any error or success messages from session
    String errorMessage = (String) session.getAttribute("errorMessage");
    String successMessage = (String) session.getAttribute("successMessage");
    
    // Clear messages after retrieving
    session.removeAttribute("errorMessage");
    session.removeAttribute("successMessage");
%>

<!-- Password Update Modal -->
<div id="passwordModal" class="password-modal">
    <div class="password-modal-content">
        <div class="password-modal-header">
            <h3><i class="fas fa-key"></i> Update Password</h3>
            <span class="close-modal" onclick="closePasswordModal()">&times;</span>
        </div>
        <div class="password-modal-body">
            <form id="passwordUpdateForm" action="<%= request.getContextPath() %>/ChangePasswordServlet" method="post">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <div class="password-field">
                        <input type="password" id="currentPassword" name="currentPassword" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('currentPassword')"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <div class="password-field">
                        <input type="password" id="newPassword" name="newPassword" required onkeyup="checkPasswordStrength()">
                        <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('newPassword')"></i>
                    </div>
                    
                    <div class="password-strength-container">
                        <div class="password-strength-bar">
                            <div id="strengthBar"></div>
                        </div>
                        <span id="strengthText">Password strength</span>
                    </div>
                    
                    <div id="requirements-message" class="requirements-message">
                        Password must contain at least 8 characters, one uppercase letter, one lowercase letter, one number, and one special character.
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <div class="password-field">
                        <input type="password" id="confirmPassword" name="confirmPassword" required onkeyup="checkPasswordMatch()">
                        <i class="fas fa-eye toggle-password" onclick="togglePasswordVisibility('confirmPassword')"></i>
                    </div>
                    <div id="passwordMatchMessage"></div>
                </div>
            </form>
        </div>
        <div class="password-modal-footer">
            <button class="btn-cancel" onclick="closePasswordModal()">Cancel</button>
            <button class="btn-update" onclick="submitPasswordUpdate()" id="updatePasswordBtn">Update Password</button>
        </div>
    </div>
</div>

<script>
// Improved toast notification function with inline styles
function showToast(message, type) {
    // Fallback for empty messages
    if (!message || message.trim() === '') {
        message = type === 'success' ? 'Password updated successfully' : 'Failed to update password';
    }
    
    // Find or create toast container
    let toastContainer = document.getElementById('passwordToastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'passwordToastContainer';
        
        // Set container styles
        toastContainer.style.position = 'fixed';
        toastContainer.style.bottom = '30px';
        toastContainer.style.right = '30px';
        toastContainer.style.zIndex = '100000';
        toastContainer.style.display = 'flex';
        toastContainer.style.flexDirection = 'column';
        toastContainer.style.gap = '10px';
        
        document.body.appendChild(toastContainer);
    }
    
    // Create toast element
    const toast = document.createElement('div');
    
    // Set toast styles
    toast.style.padding = '15px 20px';
    toast.style.borderRadius = '8px';
    toast.style.backgroundColor = '#ffffff';
    toast.style.boxShadow = '0 5px 15px rgba(0, 0, 0, 0.2)';
    toast.style.display = 'flex';
    toast.style.alignItems = 'center';
    toast.style.minWidth = '300px';
    toast.style.maxWidth = '400px';
    toast.style.marginBottom = '10px';
    toast.style.borderLeft = type === 'success' ? '4px solid #00B894' : '4px solid #FF4757';
    
    // Create icon
    const icon = document.createElement('i');
    icon.className = 'fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-circle');
    icon.style.color = type === 'success' ? '#00B894' : '#FF4757';
    icon.style.fontSize = '20px';
    icon.style.marginRight = '12px';
    
    // Create message text
    const textSpan = document.createElement('span');
    textSpan.textContent = message;
    textSpan.style.color = '#333333';
    textSpan.style.fontSize = '14px';
    textSpan.style.lineHeight = '1.4';
    textSpan.style.fontWeight = '500';
    
    // Assemble toast
    toast.appendChild(icon);
    toast.appendChild(textSpan);
    
    // Add to container
    toastContainer.appendChild(toast);
    
    // Animation
    toast.animate([
        { transform: 'translateX(100%)', opacity: 0 },
        { transform: 'translateX(0)', opacity: 1 }
    ], {
        duration: 500,
        easing: 'ease-out',
        fill: 'forwards'
    });
    
    // Remove after delay
    setTimeout(() => {
        const animation = toast.animate([
            { transform: 'translateX(0)', opacity: 1 },
            { transform: 'translateX(100%)', opacity: 0 }
        ], {
            duration: 500,
            easing: 'ease-in',
            fill: 'forwards'
        });
        
        animation.onfinish = () => {
            toast.remove();
            if (toastContainer.children.length === 0) {
                toastContainer.remove();
            }
        };
    }, 5000);
}

// Show the password update modal
function showPasswordModal() {
    document.getElementById('passwordModal').style.display = 'flex';
    document.body.style.overflow = 'hidden';
    
    // Reset form
    document.getElementById('passwordUpdateForm').reset();
    document.getElementById('updatePasswordBtn').disabled = true;
    document.getElementById('strengthBar').style.width = '0';
    document.getElementById('strengthText').textContent = 'Password strength';
    document.getElementById('passwordMatchMessage').innerHTML = '';
    
    // Reset requirement message
    const reqMessage = document.getElementById('requirements-message');
    reqMessage.classList.remove('requirements-passed');
    reqMessage.classList.remove('requirements-partial');
}

// Close the password update modal
function closePasswordModal() {
    document.getElementById('passwordModal').style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Toggle password visibility
function togglePasswordVisibility(inputId) {
    const input = document.getElementById(inputId);
    const icon = input.nextElementSibling;
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// Check password strength and requirements
function checkPasswordStrength() {
    const password = document.getElementById('newPassword').value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    const reqMessage = document.getElementById('requirements-message');
    
    // Check requirements
    const hasLength = password.length >= 8;
    const hasUpper = /[A-Z]/.test(password);
    const hasLower = /[a-z]/.test(password);
    const hasNumber = /[0-9]/.test(password);
    const hasSpecial = /[^A-Za-z0-9]/.test(password);
    
    // Calculate strength percentage
    let strength = 0;
    let metCount = 0;
    
    if (hasLength) { strength += 20; metCount++; }
    if (hasUpper) { strength += 20; metCount++; }
    if (hasLower) { strength += 20; metCount++; }
    if (hasNumber) { strength += 20; metCount++; }
    if (hasSpecial) { strength += 20; metCount++; }
    
    // Update strength bar
    strengthBar.style.width = strength + '%';
    
    // Update requirement message styling based on how many requirements are met
    reqMessage.classList.remove('requirements-passed', 'requirements-partial');
    
    if (metCount === 5) {
        reqMessage.classList.add('requirements-passed');
        reqMessage.innerHTML = '<i class="fas fa-check-circle"></i> All password requirements met';
    } else if (metCount > 0) {
        reqMessage.classList.add('requirements-partial');
    }
    
    // Set color and text based on strength
    if (strength < 40) {
        strengthBar.style.backgroundColor = '#FF4757'; // Weak - Red
        strengthText.textContent = 'Weak password';
    } else if (strength < 80) {
        strengthBar.style.backgroundColor = '#FDCB6E'; // Medium - Yellow
        strengthText.textContent = 'Medium password';
    } else {
        strengthBar.style.backgroundColor = '#00B894'; // Strong - Green
        strengthText.textContent = 'Strong password';
    }
    
    // Check if password and confirm match
    checkPasswordMatch();
    
    // Enable/disable update button
    validateForm();
}

// Check if passwords match
function checkPasswordMatch() {
    const password = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const messageElement = document.getElementById('passwordMatchMessage');
    
    if (confirmPassword.length > 0) {
        if (password === confirmPassword) {
            messageElement.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
            messageElement.className = 'match-success';
        } else {
            messageElement.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
            messageElement.className = 'match-error';
        }
    } else {
        messageElement.innerHTML = '';
    }
    
    validateForm();
}

// Validate the form to enable/disable update button
function validateForm() {
    const password = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const currentPassword = document.getElementById('currentPassword').value;
    const updateBtn = document.getElementById('updatePasswordBtn');
    
    // Check requirements
    const hasLength = password.length >= 8;
    const hasUpper = /[A-Z]/.test(password);
    const hasLower = /[a-z]/.test(password);
    const hasNumber = /[0-9]/.test(password);
    const hasSpecial = /[^A-Za-z0-9]/.test(password);
    
    // Password meets requirements, matches confirmation, and current password is filled
    const isValid = hasLength && hasUpper && hasLower && hasNumber && hasSpecial && 
                   password === confirmPassword && password.length > 0 && confirmPassword.length > 0 && 
                   currentPassword.length > 0;
                   
    updateBtn.disabled = !isValid;
}

// Submit the password update form
function submitPasswordUpdate() {
    // Final validation before submit
    const password = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const currentPassword = document.getElementById('currentPassword').value;
    
    if (!currentPassword) {
        alert('Please enter your current password');
        return;
    }
    
    if (password !== confirmPassword) {
        alert('Passwords do not match');
        return;
    }
    
    // Check requirements one more time
    const hasLength = password.length >= 8;
    const hasUpper = /[A-Z]/.test(password);
    const hasLower = /[a-z]/.test(password);
    const hasNumber = /[0-9]/.test(password);
    const hasSpecial = /[^A-Za-z0-9]/.test(password);
    
    if (!(hasLength && hasUpper && hasLower && hasNumber && hasSpecial)) {
        alert('Password does not meet all requirements');
        return;
    }
    
    // All validations passed, submit the form
    document.getElementById('passwordUpdateForm').submit();
}

// Display messages when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Check for messages and display toasts if needed
    var errorMsg = "<%= errorMessage != null ? errorMessage.replace("\"", "\\\"") : "" %>";
    var successMsg = "<%= successMessage != null ? successMessage.replace("\"", "\\\"") : "" %>";
    
    if (errorMsg && errorMsg.trim() !== "") {
        showToast(errorMsg, "error");
    }
    
    if (successMsg && successMsg.trim() !== "") {
        showToast(successMsg, "success");
    }

    const modal = document.getElementById('passwordModal');
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            closePasswordModal();
        }
    });	
    
    // Close with ESC key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && modal && modal.style.display === 'flex') {
            closePasswordModal();
        }
    });
    
    // Add input listeners
    document.getElementById('currentPassword').addEventListener('input', validateForm);
    document.getElementById('newPassword').addEventListener('input', checkPasswordStrength);
    document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
});
</script>