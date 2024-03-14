package Models

type (
	User struct {
		Email    string `json:"email" validate:"required"`
		Username string `json:"username" validate:"required"`
		Password string `json:"password" validate:"required"`
	}
	AuthUser struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	UserData struct {
	}
)
