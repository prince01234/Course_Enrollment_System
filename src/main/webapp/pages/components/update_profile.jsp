<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64" %>
<%@ page import="model.User" %>

<%
    User currentUser = (User)session.getAttribute("user");
    boolean hasProfilePicture = currentUser != null && currentUser.getProfilePicture() != null;
    String profilePicBase64 = hasProfilePicture ? 
        Base64.getEncoder().encodeToString(currentUser.getProfilePicture()) : "";
%>

<div class="profile-modal" id="profileModal">
    <div class="profile-modal-content">
        <div class="profile-modal-header">
            <h2><i class="fas fa-user-circle"></i> Update Profile</h2>
            <span class="profile-close-btn" onclick="closeProfileModal()">&times;</span>
        </div>
        
        <div class="profile-modal-body">
            <form id="updateProfileForm" action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post" enctype="multipart/form-data">
                <!-- Profile Picture Section -->
                <div class="profile-picture-section">
                    <div class="profile-picture-preview" id="profilePicturePreview">
                        <% if(hasProfilePicture) { %>
                            <img src="data:image/jpeg;base64,<%= profilePicBase64 %>" alt="Profile Picture">
                        <% } else { %>
                            <i class="fas fa-user"></i>
                        <% } %>
                    </div>
                    <div class="profile-picture-actions">
                        <button type="button" class="btn-choose" id="chooseBtn" onclick="document.getElementById('profilePicture').click()">
                            <i class="fas fa-camera"></i> Choose Photo
                        </button>
                        <input type="file" id="profilePicture" name="profilePicture" accept="image/*" onchange="previewImage(this)">
                    </div>
                    <small class="max-size-text">Max 5MB (JPG, PNG)</small>
                </div>
                
                <!-- Form Fields -->
                <div class="profile-form-fields">
                    <!-- Names Row -->
                    <div class="form-row">
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> First Name</label>
                            <input type="text" id="firstName" name="firstName" value="${sessionScope.user.firstName}" required placeholder="Enter first name">
                        </div>
                        <div class="form-group">
                            <label><i class="fas fa-user"></i> Last Name</label>
                            <input type="text" id="lastName" name="lastName" value="${sessionScope.user.lastName}" required placeholder="Enter last name">
                        </div>
                    </div>
                    
                    <!-- Phone Field -->
                    <div class="form-group">
                        <label><i class="fas fa-phone"></i> Phone</label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" value="${sessionScope.user.phoneNumber}" placeholder="Your phone number">
                    </div>
                    
                    <!-- Address Field -->
                    <div class="form-group">
                        <label><i class="fas fa-map-marker-alt"></i> Address</label>
                        <input type="text" id="address" name="address" value="${sessionScope.user.address}" placeholder="Your address">
                    </div>
                </div>
                
                <input type="hidden" id="removeProfilePicture" name="removeProfilePicture" value="false">
                
                <div class="profile-modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeProfileModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn-save">
                        Save
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Store original profile information
    const hasOriginalProfilePic = <%= hasProfilePicture %>;
    const originalProfilePicSrc = hasOriginalProfilePic ? 
        "data:image/jpeg;base64,<%= profilePicBase64 %>" : null;
    
    // Open modal function
    function openProfileModal() {
        document.getElementById('profileModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
    
    // Close modal function
    function closeProfileModal() {
        document.getElementById('profileModal').style.display = 'none';
        document.body.style.overflow = 'auto';
        resetProfileForm();
    }
    
    // Preview uploaded image
    function previewImage(input) {
        const preview = document.getElementById('profilePicturePreview');
        
        if (input.files && input.files[0]) {
            // Check file size
            if (input.files[0].size > 5 * 1024 * 1024) { // 5MB
                alert('Profile picture must be less than 5MB');
                input.value = '';
                return;
            }
            
            const reader = new FileReader();
            
            reader.onload = function(e) {
                // Set the image
                preview.innerHTML = '<img src="' + e.target.result + '" alt="Profile Preview">';
                
                // Reset remove flag
                document.getElementById('removeProfilePicture').value = "false";
            };
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    // Reset form to original values
    function resetProfileForm() {
        const form = document.getElementById('updateProfileForm');
        form.reset();
        
        // Reset profile picture preview
        const preview = document.getElementById('profilePicturePreview');
        
        if (hasOriginalProfilePic) {
            preview.innerHTML = '<img src="' + originalProfilePicSrc + '" alt="Profile Picture">';
        } else {
            preview.innerHTML = '<i class="fas fa-user"></i>';
        }
        
        // Reset the remove flag
        document.getElementById('removeProfilePicture').value = "false";
    }
    
    // Form submission handler
    document.getElementById('updateProfileForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Validate form fields
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        
        if (!firstName || !lastName) {
            alert('First name and last name are required');
            return;
        }
        
        // Submit form
        this.submit();
    });
    
    // Close modal when clicking outside
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('profileModal');
        if (event.target === modal) {
            closeProfileModal();
        }
    });
    
    // Close with ESC key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeProfileModal();
        }
    });
</script>