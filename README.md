# README
## How to Run the Project

Follow these steps to start the application:

1. **Install Ruby and Dependencies**
    ```
    ruby -v   # Check installed Ruby version
    bundle install   # Install dependencies from Gemfile
    ```

2. **Image Processing Dependencies**
    ```
    # For Ubuntu/Debian
    sudo apt-get install libvips-dev

    # For macOS
    brew install vips

    # For Windows
    # See https://libvips.github.io/libvips/install.html for instructions
    ```

3. **Set Up the Database**
    ```
    rails db:create   # Create the database
    rails db:migrate  # Run migrations
    rails db:seed     # Populate with initial data (if required)
    ```

4. **Start the Server**
    ```
    rails server   # Or shorthand: rails s
    ```

5. **Start Sidekiq**
    ```
    bundle exec sidekiq   # Start background job processing
    ```

6. **Open the Application in Browser**
    - Navigate to http://localhost:3000

## Additional Information

* Ruby version: 3.2.1

* System dependencies:
  - libvips (for image_processing gem)
  - ImageMagick (alternative backend)

* How to run the test suite: `rspec`

* API documentation: Available at `/administrator/api-docs`
